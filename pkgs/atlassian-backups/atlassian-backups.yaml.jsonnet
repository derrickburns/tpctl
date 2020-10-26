local argo = import '../../lib/argo.jsonnet';
local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local backupFolder = '/opt/backups';

local workflowSpec(me, backup) = k8s.k('argoproj.io/v1alpha1', 'WorkflowTemplate') + k8s.metadata('atlassian-%s-backup' % backup.name, me.namespace) {
  local prometheusMetricsBackupStatus = {
    name: 'atlassian_backup_status',
    help: 'Status indication of Atlassian backups tests',
    labels: [
      {
        key: 'backup_name',
        value: '%s' % backup.name,
      },
    ],
  },
  spec: {
    entrypoint: 'atlassian-%s-backup' % backup.name,
    serviceAccountName: 'atlassian-backups-s3',
    affinity: {
      nodeAffinity: k8s.nodeAffinity(),
    },
    tolerations: [k8s.toleration()],
    imagePullSecrets: [
      {
        name: 'docker-hub',
      },
    ],
    volumeClaimTemplates: [
      {
        metadata: {
          name: me.pkg,
        },
        spec: {
          accessModes: ['ReadWriteOnce'],
          resources: {
            requests: {
              storage: '40Gi',
            },
          },
        },
      },
    ],
    templates: [
      {
        name: 'atlassian-%s-backup' % backup.name,
        dag: {
          tasks: [
            {
              name: 'create-backup',
              template: 'create-backup',
            },
            {
              name: 'upload-backup',
              template: 'upload-backup',
              dependencies: [
                'create-backup',
              ],
            },
            {
              name: 'clean-up',
              template: 'clean-up',
              dependencies: [
                'upload-backup',
              ],
            },
          ],
        },
      },
      {
        name: 'create-backup',
        container: {
          name: 'atlassian-%s-backup' % backup.name,
          image: 'tidepool/atlassian-backups:v0.2.0',
          command: [
            'python',
            '%s_backup.py' % backup.name,
          ],
          args: [
            '--folder=%s/' % backupFolder,
          ] + backup.extraArgs,
          volumeMounts: [
            {
              mountPath: backupFolder,
              name: me.pkg,
            },
          ],
          envFrom: [{
            secretRef: {
              name: 'atlassian-backups',
            },
          }],
        },
      },
      {
        name: 'upload-backup',
        metrics: {
          prometheus: [
            {
              when: '{{status}} == Failed',
              gauge: {
                value: '0',
              },
            } + prometheusMetricsBackupStatus,
            {
              when: '{{status}} == Succeeded',
              gauge: {
                value: '1',
              },
            } + prometheusMetricsBackupStatus,
          ],
        },
        container: {
          name: 's3-upload',
          image: 'amazon/aws-cli:2.0.24',
          command: [
            'aws',
            's3',
            'cp',
          ],
          args: [
            backupFolder,
            's3://tidepool-%s-backup' % backup.name,
            '--recursive',
            '--storage-class=GLACIER',
          ],
          volumeMounts: [
            {
              mountPath: backupFolder,
              name: me.pkg,
            },
          ],
        },
      },
      {
        name: 'clean-up',
        container: {
          name: 'clean-up',
          image: 'alpine:3',
          command: [
            'rm',
          ],
          args: [
            '-rf',
            '%s/*' % backupFolder,
          ],
          volumeMounts: [
            {
              mountPath: backupFolder,
              name: me.pkg,
            },
          ],
        },
      },
    ],
  },
};

local cronJob(me, backup) = k8s.k('argoproj.io/v1alpha1', 'CronWorkflow') + k8s.metadata('atlassian-%s-backup' % backup.name, me.namespace) {
  spec: {
    schedule: backup.schedule,
    timezone: 'Etc/UTC',
    failedJobsHistoryLimit: 6,
    successfulJobsHistoryLimit: 6,
    workflowSpec: {
      workflowTemplateRef: {
        name: 'atlassian-%s-backup' % backup.name,
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local defaultJiraConfluenceArgs = [
    '--site=tidepool',
    '--user=adin@tidepool.org',
    '--token=$(ATLASSIAN_TOKEN)',
  ];
  local backups = [
    {
      name: 'jira',
      schedule: '0 12 1,15 * *',
      extraArgs: defaultJiraConfluenceArgs,
    },
    {
      name: 'confluence',
      extraArgs: ['--attachments=y'] + defaultJiraConfluenceArgs,
      schedule: '0 14 1,15 * *',
    },
    {
      name: 'xray',
      schedule: '0 16 1,15 * *',
      extraArgs: [],
    },
  ];
  local me = common.package(config, prev, namespace, pkg);
  [argo.roleBinding(me, 'argo-atlassian-backups-s3', 'atlassian-backups-s3')] + [workflowSpec(me, backupItem) for backupItem in backups] + [cronJob(me, backupItem) for backupItem in backups]
)

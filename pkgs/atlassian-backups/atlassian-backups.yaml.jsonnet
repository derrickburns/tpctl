local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local backupFolder = '/opt/backups';

local backup(me, backup) = k8s.k('batch/v1beta1', 'CronJob') + k8s.metadata('atlassian-%s-backup' % backup.name, me.namespace) {
  spec+: {
    schedule: backup.schedule,
    jobTemplate: {
      spec+: {
        backoffLimit: 0,
        template: {
          spec: {
            affinity: {
              nodeAffinity: k8s.nodeAffinity(),
            },
            tolerations: [k8s.toleration()],
            restartPolicy: 'Never',
            containers+: [
              {
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
            ],
            initContainers+: [
              {
                name: 'atlassian-%s-backup' % backup.name,
                image: 'tidepool/atlassian-backups:v0.1.0',
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
            ],
            serviceAccountName: 'atlassian-backups-s3',
            imagePullSecrets: [
              {
                name: 'docker-hub',
              },
            ],
            volumes: [
              {
                name: me.pkg,
                emptyDir: {},
              },
            ],
          },
        },
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
      schedule: '0 13 1,15 * *',
    },
    {
      name: 'xray',
      schedule: '0 14 1,15 * *',
      extraArgs: [],
    },
  ];
  local me = common.package(config, prev, namespace, pkg);
  [backup(me, backupItem) for backupItem in backups]
)

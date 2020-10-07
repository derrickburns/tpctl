local argo = import '../../lib/argo.jsonnet';
local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local workflowSpec(me, test) = k8s.k('argoproj.io/v1alpha1', 'WorkflowTemplate') + k8s.metadata('k6-%s-%s' % [test.name, test.env], me.namespace) {
  spec: {
    serviceAccountName: 'account-tool',
    entrypoint: 'k6-%s-%s' % [test.name, test.env],
    imagePullSecrets: [
      {
        name: 'docker-hub',
      },
    ],
    affinity: {
      nodeAffinity: k8s.nodeAffinity(),
    },
    tolerations: [k8s.toleration()],
    volumeClaimTemplates: [
      {
        metadata: {
          name: me.pkg,
        },
        spec: {
          accessModes: ['ReadWriteOnce'],
          resources: {
            requests: {
              storage: '1Gi',
            },
          },
        },
      },
    ],
    templates: [
      {
        name: 'k6-%s-%s' % [test.name, test.env],
        dag: {
          tasks: [
            {
              name: 'get-credentials',
              template: 'get-credentials',
            },
            {
              name: 'run-api-tests',
              template: 'run-api-tests',
              dependencies: [
                'get-credentials',
              ],
            },
          ],
        },
      },
      {
        name: 'run-api-tests',
        container: {
          name: 'k6-%s-%s' % [test.name, test.env],
          image: 'tidepool/loadtest:v0.1.0',
          local statsd = global.package(me.config, 'statsd-exporter'),
          local influxdb = global.package(me.config, 'influxdb'),
          env: if global.isEnabled(me.config, 'statsd-exporter') then [
            k8s.envVar('K6_STATSD_ADDR', 'statsd-exporter.%s:9125' % statsd.namespace),
            k8s.envVar('K6_STATSD_NAMESPACE', 'k6_%s' % test.env),
          ] else [],
          command: [
            'k6',
            'run',
          ],
          args: [
            '-e',
            'csv=/opt/accounts/Account-Credentials.csv',
            '-e',
            'env=%s' % test.env,
            '--out',
            'influxdb=http://influxdb.%s:8086/k6' % influxdb.namespace,
            '--tag',
            'env=%s' % test.env,
          ] + test.args,
          volumeMounts: [
            {
              mountPath: '/opt/accounts',
              name: me.pkg,
            },
          ],
        },
      },
      {
        name: 'get-credentials',
        container: {
          name: 's3-fetch-%s' % test.env,
          image: 'amazon/aws-cli:2.0.24',
          command: [
            'aws',
            's3',
            'cp',
          ],
          args: [
            's3://tidepool-account-tool/%s-credentials.csv' % test.env,
            '/opt/accounts/Account-Credentials.csv',
          ],
          volumeMounts: [
            {
              mountPath: '/opt/accounts',
              name: me.pkg,
            },
          ],
        },
      },
    ],
  },
};

local cronJob(me, test) = k8s.k('argoproj.io/v1alpha1', 'CronWorkflow') + k8s.metadata('k6-%s-%s' % [test.name, test.env], me.namespace) {
  spec: {
    schedule: test.cronJob.schedule,
    timezone: 'Etc/UTC',
    failedJobsHistoryLimit: 6,
    successfulJobsHistoryLimit: 6,
    suspend: test.cronJob.suspend,
    workflowSpec: {
      workflowTemplateRef: {
        name: 'k6-%s-%s' % [test.name, test.env],
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [argo.roleBinding(me, 'argo-account-tool', 'account-tool')] + [workflowSpec(me, test) for test in me.tests] + [cronJob(me, test) for test in me.tests if test.cronJob.enabled == true]
)

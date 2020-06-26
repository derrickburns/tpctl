local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local cronJob(me, test) = k8s.k('batch/v1beta1', 'CronJob') + k8s.metadata('k6-%s-%s' % [test.name, test.env], me.namespace) {
  spec+: {
    schedule: test.schedule,
    jobTemplate: {
      spec: {
        ttlSecondsAfterFinished: 100,
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
                name: 'k6-%s-%s' % [test.name, test.env],
                image: 'tidepool/loadtest:latest',
                env: if global.isEnabled(me.config, 'statsd-exporter') then [
                  k8s.envVar('K6_STATSD_ADDR', 'statsd-exporter.monitoring:9125'),
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
                  'statsd',
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
            ],
            initContainers+: [
              {
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
            ],
            serviceAccountName: 'account-tool',
            imagePullSecrets: [
              { name: 'docker-hub' },
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
  local me = common.package(config, prev, namespace, pkg);
  [cronJob(me, test) for test in me.tests]
)

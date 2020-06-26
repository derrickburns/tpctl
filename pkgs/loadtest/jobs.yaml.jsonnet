local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local cronJob(me, job) = k8s.k('batch/v1beta1', 'CronJob') + k8s.metadata('loadtest', me.namespace) {
  spec+: {
    schedule: job.schedule,
    template: {
      spec: {
        affinity: {
          nodeAffinity: k8s.nodeAffinity(),
        },
        tolerations: [k8s.toleration()],
        restartPolicy: 'Never',
        containers+: [
          {
            image: 'tidepool/loadtest:latest',
            env: if global.isEnabled(me.config, 'statsd-exporter') then [
              k8s.envVar('K6_STATSD_ADDR', 'statsd-exporter:9125'),
            ] else [],
            command: [
              'k6',
              'run',
              '-e',
              'csv=/opt/k6/%s-Credentials.csv' % me.studyID,
              '-e',
              'env=dev1',
              '--out',
              'statsd',
              job.name,
            ],
            volumeMounts: [
              {
                mountPath: '/opt/k6',
                name: me.pkg,
              },
            ],
          },
        ],
        volumes: [
          {
            name: me.pkg,
            persistentVolumeClaim: {
              claimName: me.pkg,
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  // [cronJob(me, test) for test in me.tests]
  []
)

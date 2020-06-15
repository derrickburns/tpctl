local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local affinity = {
  nodeAffinity: {
    requiredDuringSchedulingIgnoredDuringExecution: {
      nodeSelectorTerms: [{
        matchExpressions: [
          {
            key: 'role',
            operator: 'In',
            values: ['monitoring'],
          },
        ],
      }],
    },
  },
};

local tolerations = [
  {
    key: 'role',
    operator: 'Equal',
    value: 'monitoring',
    effect: 'NoSchedule',
  },
];

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        affinity: affinity,
        tolerations: tolerations,
        containers: [
          {
            image: lib.getElse(me, 'image', 'prom/statsd-exporter:v0.16.0'),
            name: me.pkg,
            ports: [
              { containerPort: 9125 },
              { containerPort: 9102 },
            ],
            resources: {
              limits: {
                cpu: lib.getElse(me, 'limits.cpu', '15m'),
                memory: lib.getElse(me, 'limits.memory', '20M'),
              },
              requests: {
                cpu: '5m',
                memory: '10M',
              },
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) (deployment(common.package(config, prev, namespace, pkg)))

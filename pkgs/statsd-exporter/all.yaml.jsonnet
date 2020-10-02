local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local prometheus = import '../../lib/prometheus.jsonnet';

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

local deployment(me) = k8s.deployment(me,
                                      containers={
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
                                      }) {

  spec+: {
    template+: {
      spec+: {
        affinity: affinity,
        tolerations: tolerations,

      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(9102, 9102, 'metrics'), k8s.port(9125, 9125, 'tcp'), k8s.port(9125, 9125, 'udp', 'UDP')],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  (if global.isEnabled(me.config, 'kube-prometheus-stack') then [prometheus.servicemonitor(me, 'metrics')] else []) +
  [
    service(me),
    deployment(me),
  ]
)

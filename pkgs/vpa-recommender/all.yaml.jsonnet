local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local sa(me) = k8s.serviceaccount(me) {};

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        serviceAccountName: me.pkg,
        containers: [
          {
            name: me.pkg,
            image: 'us.gcr.io/k8s-artifacts-prod/autoscaling/vpa-recommender:%s' % lib.getElse(me, 'version', '0.8.0'),
            imagePullPolicy: 'IfNotPresent',
            args: [
              '--storage=prometheus',
              '--prometheus-address=http://prometheus-operator-prometheus.monitoring:9090',
            ],
            ports: [{
              containerPort: 8080,
            }],
            resources: {
              limits: {
                cpu: '200m',
                memory: '1000Mi',
              },
              requests: {
                cpu: '50m',
                memory: '500Mi',
              },
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    sa(me),
    deployment(me),
  ]
)

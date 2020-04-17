local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local statefulset(me) = k8s.statefulset(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            args: [
              'manager',
              '--operator-roles',
              'all',
              '--enable-debug-logs=false',
            ],
            env: [
              k8s.envField('OPERATOR_NAMESPACE', 'metadata.namespace'),
              k8s.envValue('WEBHOOK_SECRET', 'webhook-server-secret'),
              k8s.envValue('WEBHOOK_PODS_LABEL', me.pkg),
              k8s.envValue('OPERATOR_IMAGE', 'docker.elastic.co/eck/eck-operator:1.0.0-beta1'),
            ],
            image: 'docker.elastic.co/eck/eck-operator:1.0.0-beta1',
            name: 'manager',
            ports: [
              {
                containerPort: 9876,
                name: 'webhook-server',
                protocol: 'TCP',
              },
            ],
            resources: {
              limits: {
                cpu: 1,
                memory: '150Mi',
              },
              requests: {
                cpu: '100m',
                memory: '50Mi',
              },
            },
          },
        ],
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 10,
      },
    },
  },
};

function(config, prev, namespace, pkg) statefulset(common.package(config, prev, namespace, pkg))

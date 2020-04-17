local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            args: [
              'start',
            ],
            env: [
              k8s.envVar('WATCH_NAMESPACE', ''),
              k8s.envField('POD_NAME', 'metadata.name'),
              k8s.envField('POD_NAMESPACE', 'metadata.namespace'),
              k8s.envVar('OPERATOR_NAME', me.pkg),
            ],
            image: 'jaegertracing/jaeger-operator:1.17.0',
            imagePullPolicy: 'Always',
            name: me.pkg,
            ports: [
              {
                containerPort: 8383,
                name: 'metrics',
              },
            ],
          },
        ],
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

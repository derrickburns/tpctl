local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local deployment(me) = k8s.deployment(me) + flux.metadata() {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            image: 'tidepool/external-auth:latest',
            imagePullPolicy: 'Always',
            name: me.pkg,
            env: [k8s.envSecret('API_SECRET', 'shoreline', 'ServiceAuth')],
            ports: [{ containerPort: 4000 }],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

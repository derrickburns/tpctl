local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            image: 'tidepool/external-auth:latest',
            imagePullPolicy: 'Always',
            name: 'external-auth',
            env: [
              {
                name: 'API_SECRET',
                valueFrom: {
                  secretKeyRef: {
                    name: 'shoreline',
                    key: 'ServiceAuth',
                  },
                },
              },
            ],
            ports: [{
              containerPort: 4000,
            }],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

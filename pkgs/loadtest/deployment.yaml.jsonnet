local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  metadata+: {
    labels: {
      app: me.pkg,
    },
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: me.pkg,
      },
    },
    template: {
      metadata: {
        labels: {
          app: me.pkg,
        },
      },
      spec: {
        containers: [
          {
            image: 'tidepool/loadtest:latest',
            imagePullPolicy: 'Always',
            name: 'loadtest',
            env: [
            ],
            ports: [
            ],
          },
        ],
        restartPolicy: 'Always',
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

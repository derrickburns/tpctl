local lib = import '../../lib/lib.jsonnet';

local deployment(me) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: me.pkg,
    },
    name: me.pkg,
    namespace: me.namespace,
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
            image: 'tidepool/external-auth:latest',
            imagePullPolicy: 'Always',
            name: 'external-auth',
            env: [
            ],
            ports: [{
              containerPort: 4000,
            }],
          },
        ],
        restartPolicy: 'Always',
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

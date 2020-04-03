local lib = import '../../lib/lib.jsonnet';
local k8s  = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  metadata+: {
    annotations: {
      'secret.reloader.stakater.com/reload': 'mongo',
    },
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
    strategy: {
      type: 'Recreate',
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
            env: [
              {
                name: 'INSTALL_MONGO',
                value: 'false',
              },
              {
                name: 'MONGO_SCHEME',
                valueFrom: {
                  secretKeyRef: {
                    key: 'Scheme',
                    name: 'mongo',
                  },
                },
              },
              {
                name: 'MONGO_USERNAME',
                valueFrom: {
                  secretKeyRef: {
                    key: 'Username',
                    name: 'mongo',
                  },
                },
              },
              {
                name: 'MONGO_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    key: 'Password',
                    name: 'mongo',
                    optional: true,
                  },
                },
              },
              {
                name: 'MONGO_ADDRESSES',
                valueFrom: {
                  secretKeyRef: {
                    key: 'Addresses',
                    name: 'mongo',
                  },
                },
              },
              {
                name: 'MONGO_OPT_PARAMS',
                valueFrom: {
                  secretKeyRef: {
                    key: 'OptParams',
                    name: 'mongo',
                  },
                },
              },
              {
                name: 'MONGO_TLS',
                valueFrom: {
                  secretKeyRef: {
                    key: 'Tls',
                    name: 'mongo',
                  },
                },
              },
            ],
            image: 'tidepool/nosqlclient:2.3.2',
            name: 'nosqlclient',
            ports: [
              {
                containerPort: 3000,
              },
            ],
          },
        ],
        restartPolicy: 'Always',
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))


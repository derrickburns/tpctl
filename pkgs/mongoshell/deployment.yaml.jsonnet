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
            args: [
              '$(MONGO_SCHEME)://$(MONGO_USERNAME):$(MONGO_PASSWORD)@$(MONGO_ADDRESSES)/$(MONGO_DATABASE)?ssl=$(MONGO_SSL)&$(MONGO_OPT_PARAMS)',
            ],
            command: [
              'mongo',
            ],
            image: 'mongo:3.6.17',
            name: 'mongo',
            env: [
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
                name: 'MONGO_SSL',
                valueFrom: {
                  secretKeyRef: {
                    key: 'Tls',
                    name: 'mongo',
                  },
                },
              },
            ],
            ports: [
              {
                containerPort: 27017,
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

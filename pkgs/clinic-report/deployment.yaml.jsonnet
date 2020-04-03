local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
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
            image: 'tidepool/clinic-report:latest',
            imagePullPolicy: 'Always',
            name: 'mongo',
            env: [
              {
                name: 'SALT_DEPLOY',
                valueFrom: {
                  secretKeyRef: {
                    key: 'UserIdSalt',
                    name: 'userdata',
                  },
                },
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
                name: 'MONGO_DATABASE',
                value: 'user',
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
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

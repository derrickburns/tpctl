local lib = import '../../lib/lib.jsonnet';

local deployment(config, namespace) =
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'mongoproxy',
      namespace: namespace,
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          name: 'mongoproxy',
        },
      },
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          labels: {
            name: 'mongoproxy',
          },
        },
        spec: {
          containers: [
            {
              name: 'mongoproxy',
              image: 'tidepool/mongoproxy:latest',
              imagePullPolicy: 'IfNotPresent',
              ports: [{
                containerPort: 27017,
              }],
              env: [
                {
                  name: 'MONGO_SCHEME',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Scheme',
                    },
                  },
                },
                {
                  name: 'MONGO_ADDRESSES',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Addresses',
                    },
                  },
                },
                {
                  name: 'MONGO_USERNAME',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Username',
                    },
                  },
                },
                {
                  name: 'MONGO_PASSWORD',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Password',
                    },
                  },
                },
                {
                  name: 'MONGO_DATABASE',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Database',
                    },
                  },
                },
                {
                  name: 'MONGO_OPT_PARAMS',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'OptParams',
                    },
                  },
                },
                {
                  name: 'MONGO_TLS',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Tls',
                    },
                  },
                },
                {
                  name: 'MONGOPROXY_TIMEOUT',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Timeout',
                    },
                  },
                },
                {
                  name: 'MONGOPROXY_READONLY',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Readonly',
                    },
                  },
                },
                {
                  name: 'MONGOPROXY_PORT',
                  value: '27017',
                },
              ],
            },
          ],
          restartPolicy: 'Always',
        },
      },
    },
  };

function(config, prev, namespace) deployment(config, namespace)

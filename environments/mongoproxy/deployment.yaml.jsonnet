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
                  name: 'SCHEME',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Scheme',
                    },
                  },
                },
                {
                  name: 'ADDRESSES',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Addresses',
                    },
                  },
                },
                {
                  name: 'USERNAME',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Username',
                    },
                  },
                },
                {
                  name: 'PASSWORD',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Password',
                    },
                  },
                },
                {
                  name: 'DATABASE',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Database',
                    },
                  },
                },
                {
                  name: 'OPT_PARAMS',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'OptParams',
                    },
                  },
                },
                {
                  name: 'TLS',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Tls',
                    },
                  },
                },
                {
                  name: 'TIMEOUT',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Timeout',
                    },
                  },
                },
                {
                  name: 'READONLY',
                  valueFrom: {
                    secretKeyRef: {
                      name: 'mongoproxy',
                      key: 'Readonly',
                    },
                  },
                },
                {
                  name: 'PORT',
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

local deployment(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'mongomirror',
    },
    name: 'mongomirror',
    namespace: namespace,
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'mongomirror',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'mongomirror',
        },
      },
      spec: {
        containers: [
          {
            args: [
              '--host',
              '$(HOST)',
              '--ssl',
              '--destination',
              '$(DESTINATION)',
              '--destinationUsername',
              '$(DESTINATION_USERNAME)',
              '--destinationPassword',
              '$(DESTINATION_PASSWORD)',
              '--sslCAFile',
              '/tmp/certs/ca.crt',
              '--drop',
              '--httpStatusPort',
              '8080',
              '--bookmarkFile',
              '/bookmark/mongomirror.timestamp',
            ],
            command: [
              '/mongomirror/bin/mongomirror',
            ],
            env: [
              {
                name: 'HOST',
                valueFrom: {
                  secretKeyRef: {
                    key: 'HOST',
                    name: 'mongomirror',
                  },
                },
              },
              {
                name: 'DESTINATION',
                valueFrom: {
                  secretKeyRef: {
                    key: 'DESTINATION',
                    name: 'mongomirror',
                  },
                },
              },
              {
                name: 'DESTINATION_USERNAME',
                valueFrom: {
                  secretKeyRef: {
                    key: 'DESTINATION_USERNAME',
                    name: 'mongomirror',
                  },
                },
              },
              {
                name: 'DESTINATION_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    key: 'DESTINATION_PASSWORD',
                    name: 'mongomirror',
                  },
                },
              },
            ],
            image: 'tidepool/mongomirror:latest',
            name: 'mongomirror',
            ports: [
              {
                containerPort: 8080,
              },
            ],
            volumeMounts: [
              {
                mountPath: '/tmp/certs',
                name: 'certs',
                readOnly: true,
              },
            ],
          },
        ],
        restartPolicy: 'Always',
        volumes: [
          {
            name: 'certs',
            secret: {
              defaultMode: 256,
              secretName: 'mongomirror',
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(namespace)

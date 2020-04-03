local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
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

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

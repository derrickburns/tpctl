local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

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
              k8s.envSecret('HOST', me.pkg, 'HOST'),
              k8s.envSecret('DESTINATION', me.pkg, 'DESTINATION'),
              k8s.envSecret('DESTINATION_USERNAME', me.pkg, 'DESTINATION_USERNAME'),
              k8s.envSecret('DESTINATION_PASSWORD', me.pkg, 'DESTINATION_PASSWORD'),
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

local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers: {
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
    _env:: {
      HOST: k8s._envSecret(me.pkg, 'HOST'),
      DESTINATION: k8s._envSecret(me.pkg, 'DESTINATION'),
      DESTINATION_USERNAME: k8s._envSecret(me.pkg, 'DESTINATION_USERNAME'),
      DESTINATION_PASSWORD: k8s._envSecret(me.pkg, 'DESTINATION_PASSWORD'),
    },
    image: 'tidepool/mongomirror:latest',
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
  spec+: {
    template+: {
      spec+: {
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

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

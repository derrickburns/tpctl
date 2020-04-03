local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local Deployment(config, me) = k8s.deployment(me) {
  local secretName = lib.getElse(me, 'secret', 'slack'),
  metadata+: {
    annotations: {
      'secret.reloader.stakater.com/reload': secretName,
    },
  },
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            name: me.pkg,
            image: 'justinbarrick/fluxcloud:v0.3.9',
            ports: [
              {
                containerPort: 3032,
              },
            ],
            env: [
              {
                name: 'SLACK_URL',
                valueFrom: {
                  secretKeyRef: {
                    name: secretName,
                    key: 'url',
                  },
                },
              },
              {
                name: 'SLACK_CHANNEL',
                value: lib.getElse(me, 'channel', '#flux-%s' % config.cluster.metadata.name),
              },
              {
                name: 'SLACK_USERNAME',
                value: lib.getElse(me, 'username', 'derrickburns'),
              },
              {
                name: 'SLACK_ICON_EMOJI',
                value: ':heart:',
              },
              {
                name: 'GITHUB_URL',
                value: config.general.github.https,
              },
              {
                name: 'LISTEN_ADDRESS',
                value: ':3032',
              },
            ],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) Deployment(config, lib.package(config, namespace, pkg))

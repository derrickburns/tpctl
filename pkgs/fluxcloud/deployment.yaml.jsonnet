local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

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
              k8s.envSecret('SLACK_URL', secretName, 'url'),
              k8s.envVar('SLACK_CHANNEL', lib.getElse(me, 'channel', '#flux-%s' % config.cluster.metadata.name)),
              k8s.envVar('SLACK_USERNAME', lib.getElse(me, 'username', 'derrickburns')),
              k8s.envVar('SLACK_ICON_EMOJI', ':heart:'),
              k8s.envVar('GITHUB_URL', config.general.github.https),
              k8s.envVar('LISTEN_ADDRESS', ':3032'),
            ],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) Deployment(config, lib.package(config, namespace, pkg))

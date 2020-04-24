local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(config, me) = k8s.deployment(me) {
  _containers:: {
    image: 'justinbarrick/fluxcloud:v0.3.9',
    ports: [
      {
        containerPort: 3032,
      },
    ],
    _env:: {
      SLACK_URL: k8s._envSecret( lib.getElse(me, 'secret', 'slack'), 'url'),
      SLACK_CHANNEL: { value: lib.getElse(me, 'channel', '#flux-%s' % config.cluster.metadata.name) },
      SLACK_USERNAME: { value: lib.getElse(me, 'username', 'derrickburns') },
      SLACK_ICON_EMOJI: { value: ':heart:' },
      GITHUB_URL: { value: config.general.github.https },
      LISTEN_ADDRESS: { value: ':3032' },
    },
  },
};

function(config, prev, namespace, pkg) deployment(config, common.package(config, prev, namespace, pkg))

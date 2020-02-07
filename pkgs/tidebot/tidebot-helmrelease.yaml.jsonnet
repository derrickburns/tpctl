local lib = import '../../lib/lib.jsonnet';
local lib = import '../../lib/k8s.jsonnet';

local helmrelease(config, prev) = k8s.helmrelease('tidebot', 'tidebot', '0.2.0', 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master/') {
  local tidebot = config.pkgs.tidebot,
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'true',
      'repository.fluxcd.io/slack-tidebot': 'deployment.image',
      'fluxcd.io/tag.slack-tidebot': lib.getElse(tidebot, 'gitops', 'glob:master-*'),
    },
  },

  spec+: lib.merge({
    values+: {
      deployment+: {
        image: lib.getElse(prev, 'spec.values.deployment.image', 'tidepool/slack-tidebot:master-5783cd86c2ed10f6f107047c6d60944e4cdadc6b'),
      },
      configmap+: {
        enabled: true,
      },
    },
  }, lib.getElse(tidebot, 'spec', {})),
};

function(config, prev) helmrelease(config, prev)

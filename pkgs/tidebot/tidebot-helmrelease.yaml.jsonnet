local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, prev) = {
  local tidebot = config.pkgs.tidebot,
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    name: 'tidebot',
    namespace: 'tidebot',
    annotations: {
      'fluxcd.io/automated': 'true',
      'repository.fluxcd.io/slack-tidebot': 'deployment.image',
      'fluxcd.io/tag.slack-tidebot': lib.getElse(tidebot, 'gitops', 'glob:master-*')
    },
  },

  spec+: lib.merge({
    chart+: {
      git: 'git@github.com:tidepool-org/slack-tidebot',
      path: 'deploy',
      ref: 'master',
    },
    releaseName: 'tidebot',
    values+: {
      deployment+: {
        image: lib.getElse(prev, 'spec.values.deployment.image', 'tidepool/slack-tidebot:master-5783cd86c2ed10f6f107047c6d60944e4cdadc6b'),
      },
      configmap+: {
        enabled: true,
      },
    },
  },lib.getElse(tidebot, 'spec', {})),
};

function(config, prev) helmrelease(config, prev)

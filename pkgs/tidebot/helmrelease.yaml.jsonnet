local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local githelmrelease(config, prev, namespace) =
  k8s.helmrelease('tidebot', namespace, 'git@github.com:tidepool-org/slack-tidebot', 'master', 'deploy') {
    local tidebot = config.namespaces[namespace].tidebot,
    metadata+: {
      annotations+: {
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

function(config, prev, namespace) helmrelease(config, prev, namespace)

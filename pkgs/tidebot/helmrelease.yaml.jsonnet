local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, prev, me) =
  k8s.helmrelease(me, { git: 'git@github.com:tidepool-org/slack-tidebot', path: 'deploy' }) {
    metadata+: {
      annotations+: {
        'fluxcd.io/automated': 'true',
        'repository.fluxcd.io/tidebot': 'deployment.image',
        'fluxcd.io/tag.tidebot': lib.getElse(me, 'gitops', 'regex:master-[0-9A-Za-z]{40}'),
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
    }, lib.getElse(me, 'spec', {})),
  };

function(config, prev, namespace, pkg) helmrelease(config, prev, common.package(config, prev, namespace, pkg))

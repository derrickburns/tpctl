local lib = import '../../lib/lib.jsonnet';

local helmrelease(config) = {
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

  // convert the configmap data to json strings
  local pkgConfig = lib.merge(tidebot, {
    spec+: {
      values+: {
        configmap+: {
          data_: lib.manifestJsonFields( lib.getElse(tidebot, 'spec.values.configmap.data_', {}))
        }
      }
    }
  }),

  spec: {
    chart+: {
      git: 'git@github.com:tidepool-org/slack-tidebot',
      path: 'deploy',
      ref: 'master',
    },
    releaseName: 'tidebot',
    values+: {
      deployment+: {
        image: 'tidepool/slack-tidebot:master-5783cd86c2ed10f6f107047c6d60944e4cdadc6b'
      },
      configmap+: {
        enabled: true,
        HUBOT_GITHUB_EVENT_NOTIFIER_TYPES: 'commit_comment,create,delete,deployment,deployment_status,issue_comment,issues,page_build,pull_request_review_comment,pull_request,push,repository,release,status,ping,pull_request_review',
        HUBOT_SLACK_ACCOUNT: 'Tidepool',
        HUBOT_SLACK_ROOMS: 'tidebot,github-events',
      },
    },
  } + lib.getElse(pkgConfig, 'spec', {}),
};

function(config) helmrelease(config)

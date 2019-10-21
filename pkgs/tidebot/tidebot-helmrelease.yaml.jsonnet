local lib = import '../../lib/lib.jsonnet';

local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    name: 'tidebot',
    namespace: 'tidebot',
    annotations: {
      'fluxcd.io/automated': 'true',
      'repository.fluxcd.io/tidebot': 'image',
      'fluxcd.io/tag.tidebot': lib.getElse(config, 'pkgs.tidebot.gitops', 'glob:develop-*')
    },
  },
  local tidebot = config.pkgs.tidebot,
  spec: {
    chart: {
      git: 'git@github.com:tidepool-org/slack-tidebot',
      path: 'deploy',
      ref: 'k8s',
    },
    releaseName: 'tidebot',
    values: {
      image: 'tidepool/tidebot:latest',
      ingress: tidebot.ingress,
      configmap: {
        enabled: true,
        data_: {
          HUBOT_GITHUB_EVENT_NOTIFIER_TYPES: lib.getElse(tidebot,
                                                         'HUBOT_GITHUB_EVENT_NOTIFIER_TYPES',
                                                         'commit_comment,create,delete,deployment,deployment_status,issue_comment,issues,page_build,pull_request_review_comment,pull_request,push,repository,release,status,ping,pull_request_review'),
          HUBOT_SLACK_ACCOUNT: lib.getElse(tidebot, 'HUBOT_SLACK_ACCOUNT', 'Tidepool'),
          HUBOT_SLACK_ROOMS: lib.getElse(tidebot, 'HUBOT_SLACK_ROOMS', 'tidebot,github-events'),
        },
      },
    },
  },
};

function(config) helmrelease(config)

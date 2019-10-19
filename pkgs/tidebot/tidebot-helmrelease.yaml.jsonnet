local get(x, path, sep='.') = (
  local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
  std.foldl(foldFunc, std.split(path, sep), x)
);

local getElse(x, path, default) = (
  local found = get(x, path);
  if found == null then default else found
);

local helmrelease(config) = {
  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    name: "tidebot",
    namespace: "tidebot"
  },
  local tidebot=config.pkgs.tidebot,
  spec: {
    chart: {
      git: "git@github.com:tidepool-org/slack-tidebot",
      path: "deploy",
      ref: "k8s"
    },
    releaseName: "tidebot",
    values: {
      ingress: tidebot.ingress,
      }
    }
    configmap: {
      data_: {
         HUBOT_GITHUB_EVENT_NOTIFIER_TYPES: getElse(tidebot, 'HUBOT_GITHUB_EVENT_NOTIFIER_TYPES', 
           "commit_comment,create,delete,deployment,deployment_status,issue_comment,issues,page_build,pull_request_review_comment,pull_request,push,repository,release,status,ping,pull_request_review"),
         HUBOT_SLACK_ACCOUNT: getElse(tidebot, 'HUBOT_SLACK_ACCOUNT', "Tidepool"),
         HUBOT_SLACK_ROOMS: getElse(tidebot, 'HUBOT_SLACK_ROOMS', "tidebot,github-events"),
      }
    }
  }
};

function(config) helmrelease(config)

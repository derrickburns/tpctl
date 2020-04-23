local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: [{
    name: me.pkg,
    image: 'tidepool/slack-tidebot:master-latest',
    imagePullPolicy: 'Always',
    env: [
      {
        name: 'HUBOT_CONCURRENT_REQUESTS',
        value: '1',
      },
      {
        name: 'HUBOT_GITHUB_TOKEN',
        valueFrom: {
          secretKeyRef: {
            key: 'HUBOT_GITHUB_TOKEN',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'HUBOT_SLACK_TOKEN',
        valueFrom: {
          secretKeyRef: {
            key: 'HUBOT_SLACK_TOKEN',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'HUBOT_GITHUB_EVENT_NOTIFIER_TYPES',
        valueFrom: {
          configMapKeyRef: {
            key: 'HUBOT_GITHUB_EVENT_NOTIFIER_TYPES',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'HUBOT_SLACK_ACCOUNT',
        valueFrom: {
          configMapKeyRef: {
            key: 'HUBOT_SLACK_ACCOUNT',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'HUBOT_SLACK_ROOMS',
        valueFrom: {
          configMapKeyRef: {
            key: 'HUBOT_SLACK_ROOMS',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'inputToRepoMap',
        valueFrom: {
          configMapKeyRef: {
            key: 'inputToRepoMap',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'inputToNamespaceMap',
        valueFrom: {
          configMapKeyRef: {
            key: 'inputToNamespaceMap',
            name: 'tidebot',
            optional: false,
          },
        },
      },
      {
        name: 'serviceRepoToPackage',
        valueFrom: {
          configMapKeyRef: {
            key: 'serviceRepoToPackage',
            name: 'tidebot',
            optional: false,
          },
        },
      },
    ],
    ports: [{
      containerPort: 8080,
    }],
  }],
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, 8080)],
  },
};

local configmap(me) = k8s.configmap(me) {
  data: {
    HUBOT_GITHUB_EVENT_NOTIFIER_TYPES: 'commit_comment,create,delete,deployment,deployment_status,issue_comment,issues,page_build,pull_request_review_comment,pull_request,push,repository,release,status,ping,pull_request_review',
    HUBOT_SLACK_ACCOUNT: 'Tidepool',
    HUBOT_SLACK_ROOMS: 'tidebot,github-events',
    inputToNamespaceMap: std.manifestJsonEx(
      {
        qa1: 'qa1',
        dev: 'dev1',
        qa2: 'qa2',
        int: 'external',
        integration: 'external',
        prd: 'tidepool-prod',
        prod: 'tidepool-prod',
        production: 'tidepool-prod',
        tidebot: 'tidebot',
      }, '  '
    ),
    inputToRepoMap: std.manifestJsonEx(
      {
        tidebot: 'cluster-shared',
        shared: 'cluster-shared',
        qa1: 'cluster-qa2',
        qa2: 'cluster-qa2',
        dev: 'cluster-dev',
        int: 'cluster-integration',
        integration: 'cluster-integration',
        prd: 'cluster-production',
        prod: 'cluster-production',
      }, '  '
    ),

    serviceRepoToPackage: std.manifestJsonEx(
      {
        'slack-tidebot': 'slack-tidebot',
        hydrophone: 'tidepool',
        gatekeeper: 'tidepool',
        platform: 'tidepool',
        seagull: 'tidepool',
        shoreline: 'tidepool',
        'tide-whisperer': 'tidepool',
        jellyfish: 'tidepool',
        'message-api': 'tidepool',
        blip: 'tidepool',
        export: 'tidepool',
      }, '  '
    ),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    configmap(me),
    gloo.virtualServicesForPackage(me),
  ]
)

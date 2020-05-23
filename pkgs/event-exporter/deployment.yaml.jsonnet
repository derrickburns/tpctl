local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    env: [
      k8s.envSecret('SLACK_API_TOKEN', lib.getElse(me, 'secret', me.pkg), 'slack-api-token'),
    ],
    image: 'opsgenie/kubernetes-event-exporter:0.7',
    imagePullPolicy: 'IfNotPresent',
    args: [
      "-conf=/data/config.yaml",
    ],
    volumeMounts: [
      {
        mountPath: '/data',
        name: 'config',
        subPath: 'config.yaml',
      },
    ],
  },
  spec+: {
    template+: {
      spec+: {
        serviceAccountName: me.pkg,
        volumes: [
          {
            configMap: {
              name: me.pkg,
            },
            name: 'config',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

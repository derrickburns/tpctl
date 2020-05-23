local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local configmap(me) = k8s.configmap(me) {
  data: {
    'config.yaml': std.manifestJsonEx({
      route: {
        match: [
          {
            kind: "HelmRelease",
            namespace: lib.getElse(me, 'watchNamespace', me.pkg),
            receiver: "slack"
          },
        ],
        receivers: [
          {
            name: "slack",
            slack: {
              token: "${SLACK_API_TOKEN}",
              channel: lib.getElse(me, 'channel', '#flux-%s' % me.config.cluster.metadata.name),
              message: "{{ .Message }}",
              fields: {
                namespace: "{{ .Namespace }}",
                reason: "{{ .Reason }}",
                object: "{{ .InvolvedObject.Name }}",
              }
            },
          },
        ],
      }
    }, '  '),
  },
};

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

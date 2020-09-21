local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrolebinding(me) = k8s.clusterrolebinding(me) {
  roleRef+: {
    name: 'view',
  },
};

local configmap(me) = k8s.configmap(me) {
  data: {
    'config.yaml': std.manifestJsonEx({
      route: {
        match: [
          {
            kind: 'HelmRelease',
            namespace: lib.getElse(me, 'watchNamespace', me.namespace),
            receiver: 'slack',
          },
        ],
        receivers: [
          {
            name: 'slack',
            webhook: {
              endpoint: '${SLACK_WEBHOOK_URL}',
              headers: {
                'user-agent': 'kube-event-exporter',
              },
              layout: {
                text: '{{ .Message }}',
              },
            },
          },
        ],
      },
    }, '  '),
  },
};

local deployment(me) = k8s.deployment(
  me,
  containers={
    env: [
      k8s.envSecret('SLACK_WEBHOOK_URL', lib.getElse(me, 'secret', me.pkg), 'slack-webhook-url'),
    ],
    image: 'opsgenie/kubernetes-event-exporter:0.7',
    args: [
      '-conf=/data/config.yaml',
    ],
    volumeMounts: [
      {
        mountPath: '/data/config.yaml',
        name: 'config',
        subPath: 'config.yaml',
      },
    ],
  },


  volumes=[
    {
      configMap: {
        name: me.pkg,
      },
      name: 'config',
    },
  ],
  serviceAccount=true,


);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
    clusterrolebinding(me),
    deployment(me),
    k8s.serviceaccount(me),
  ]
)

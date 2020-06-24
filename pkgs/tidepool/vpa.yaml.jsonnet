local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local expand = import '../../lib/expand.jsonnet';

local vpa(name, namespace) = {
  apiVersion: 'autoscaling.k8s.io/v1beta2',
  kind: 'VerticalPodAutoscaler',
  metadata: {
    name: name,
    namespace: namespace,
  },
  spec: {
    targetRef: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      name: name,
    },
    updatePolicy: {
      updateMode: 'Auto',
    },
  },
};

local svcs = [
  'auth',
  'blip',
  'blob',
  'data',
  'devices',
  'export',
  'gatekeeper',
  'highwater',
  'hydrophone',
  'image',
  'jellyfish',
  'messageapi',
  'migrations',
  'notification',
  'prescription',
  'seagull',
  'shoreline',
  'task',
  'tidewhisperer',
  'tools',
  'user',
];

local vpas(config, me) = (
  [vpa(svc, me.namespace) for svc in svcs if lib.getElse(me, svc + '.vpa.enabled', lib.getElse(me, 'vpa.enabled', 'false') == 'true')]
);

function(config, prev, namespace, pkg) vpas(config, common.package(config, prev, namespace, pkg))

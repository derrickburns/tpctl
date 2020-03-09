local lib = import '../../lib/lib.jsonnet';

local expand = import '../../lib/expand.jsonnet';

local vpa(name,namespace) = {
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
    'export',
    'gatekeeper',
    'highwater',
    'hydrophone',
    'image',
    'jellyfish',
    'messageapi',
    'migrations',
    'notification',
    'seagull',
    'shoreline',
    'task',
    'tidewhisperer',
    'tools',
    'user',
];

local vpas(config, namespace) = (
  local me  = config.namespaces[namespace].tidepool;
  [ vpa(svc,namespace) for svc in svcs if lib.getElse(me, svc + '.vpa.enabled', lib.isEnabled(me, 'vpa') ) ]
);

function(config, prev, namespace) std.manifestYamlStream( vpas(config,  namespace))

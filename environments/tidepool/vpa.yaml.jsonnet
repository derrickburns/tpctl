local lib = import '../../lib/lib.jsonnet';

local expand = import '../../lib/expand.jsonnet';

local vpa(name) = {
  apiVersion: 'autoscaling.k8s.io/v1beta2',
  kind: 'VerticalPodAutoscaler',
  metadata: {
    name: name,
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

local vpas(config, namespace) = [
  local env = config.environments[namespace].tidepool,
  vpa(svc) for svc in svcs if lib.getElse(env, svc + '.vpa.enabled', lib.getElse(env, 'vpa.enabled', false) )
];

function(config, prev, namespace) std.manifestYamlStream( vpas(config,  namespace))

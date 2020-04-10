local lib = import '../../lib/lib.jsonnet';

local expand = import '../../lib/expand.jsonnet';

local ports = {
  blip: 3000,  // blip service internal port
  export: 9300,  // export service internal port
  gatekeeper: 9123,  // gatekeeper service internal port
  highwater: 9191,  // highwater service internal port
  hydrophone: 9157,  // hydrophone service internal port
  jellyfish: 9122,  // jellyfish service internal port
  messageapi: 9119,  // messageapi service internal port
  auth: 9222,  // auth service internal port
  blob: 9225,  // blob service internal port
  data: 9220,  // data service internal port
  image: 9226,  // image service internal port
  notification: 9223,  // notification service internal port
  task: 9224,  // task service internal port
  user: 9221,  // user service internal port
  seagull: 9120,  // seagull service internal port
  shoreline: 9107,  // shoreline service internal port
  tidewhisperer: 9127,  // tidewhisperer service internal port
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
  'notification',
  'seagull',
  'shoreline',
  'task',
  'tidewhisperer',
  'user',
];

local canary(config, me, svc) = {
  apiVersion: 'flagger.app/v1alpha3',
  kind: 'Canary',
  metadata: {
    name: svc,
    namespace: me.namespace,
  },

  local hpa =
    if lib.getElse(me, 'hpa.enabled', false)
    then {
      autoscalerRef: {
        apiVersion: 'autoscaling/v2beta1',
        kind: 'HorizontalPodAutoscaler',
        name: svc,
      },
    }
    else {},

  spec: hpa {
    canaryAnalysis: {
      interval: '30s',
      maxWeight: 50,
      metrics: [
        {
          interval: '1m',
          name: 'request-success-rate',
          threshold: 99,
        },
        {
          interval: '30s',
          name: 'request-duration',
          threshold: 500,
        },
      ],
      stepWeight: 5,
      threshold: 5,
    },
    progressDeadlineSeconds: 60,
    service: {
      port: ports[svc],
      targetPort: ports[svc],
    },
    targetRef: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      name: svc,
    },
  },
};

local canaries(config, prev, me) = (
  [canary(config, me, svc) for svc in svcs if lib.getElse(me, svc + '.canary.enabled', false)]
);

function(config, prev, namespace, pkg) canaries(config, prev, lib.package(config, namespace, pkg))

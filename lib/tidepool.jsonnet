local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  mongo_params: [
    k8s.envSecret('TIDEPOOL_STORE_SCHEME', 'mongo', 'Scheme'),
    k8s.envSecret('TIDEPOOL_STORE_USERNAME', 'mongo', 'Username'),
    k8s.envSecret('TIDEPOOL_STORE_PASSWORD', 'mongo', 'Password'),
    k8s.envSecret('TIDEPOOL_STORE_ADDRESSES', 'mongo', 'Addresses'),
    k8s.envSecret('TIDEPOOL_STORE_OPT_PARAMS', 'mongo', 'OptParams'),
    k8s.envSecret('TIDEPOOL_STORE_SSL', 'mongo', 'Tls'),
  ],

  mongo: mongo_parmms + [
    k8s.envVar('TIDEPOOL_STORE_DATABASE', 'tidepool'),
  ],

  probes(port):: {
    livenessProbe: {
      httpGet: {
        path: '/status',
        port: port,
      },
      initialDelaySeconds: 30,
      periodSeconds: 10,
      timeoutSeconds: 5,
    },
    readinessProbe: {
      httpGet: {
        path: '/status',
        port: port,
      },
      initialDelaySeconds: 5,
      periodSeconds: 10,
      timeoutSeconds: 5,
    },
  },

  shoreline_init_container: {
    name: 'init-shoreline',
    image: 'busybox:1.31.1',
    command: ['sh', '-c', 'until nc -zvv shoreline {{.Values.global.ports.shoreline}}; do echo waiting for shoreline; sleep 2; done;'],
  },

  global: {
    default: {
      protocol: 'http',
      host: 'localhost',
    },
    proxy: {
      name: 'gateway-proxy',
      namespace: 'gloo-system',
    },
    region: 'us-west-2',
    logLevel: 'info',
    maxTimeout: '120s',
  },

  ports: {
    blip: 3000,
    export: 9300,
    gatekeeper: 9123,
    highwater: 9191,
    hydrophone: 9157,
    jellyfish: 9122,
    messageapi: 9119,
    auth: 9222,
    blob: 9225,
    data: 9220,
    image: 9226,
    notification: 9223,
    task: 9224,
    user: 9221,
    seagull: 9120,
    shoreline: 9107,
    tidewhisperer: 9127,
  },

  internal(me):: 'http://internal.%s' % me.namespace,

  clients(me):: [
    k8s.envVal('TIDEPOOL_AUTH_CLIENT_ADDRESS', 'http://auth:%d' % $.ports.auth),
    k8s.envVal('TIDEPOOL_AUTH_CLIENT_EXTERNAL_ADDRESS', internal(me)),
    k8s.envSecret('TIDEPOOL_AUTH_CLIENT_EXTERNAL_SERVER_SESSION_TOKEN_SECRET', 'server', 'ServiceAuth'),
    k8s.envVal('TIDEPOOL_BLOB_CLIENT_ADDRESS', 'http://blob:%d' % $.ports.blob),
    k8s.envVal('TIDEPOOL_DATA_CLIENT_ADDRESS', 'http://data:%d' % $.ports.data),
    k8s.envVal('TIDEPOOL_DATA_SOURCE_CLIENT_ADDRESS', 'http://data:%d' % $.ports.data),
    k8s.envSecret('TIDEPOOL_DEXCOM_CLIENT_ADDRESS', 'dexcom', 'ClientURL'),
    k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_AUTHORIZE_URL', 'dexcom', 'AuthorizeURL'),
    k8s.envVal('TIDEPOOL_IMAGE_CLIENT_ADDRESS', 'http://image:%d' % $.ports.image),
    k8s.envVal('TIDEPOOL_METRIC_CLIENT_ADDRESS', internal(me)),
    k8s.envVal('TIDEPOOL_NOTIFICATION_CLIENT_ADDRESS', 'http://notification:%d' % $.ports.notification),
    k8s.envVal('TIDEPOOL_PERMISSION_CLIENT_ADDRESS', 'http://gatekeeper:%d' % $.ports.gatekeeper),
    k8s.envVal('TIDEPOOL_TASK_CLIENT_ADDRESS', 'http://task:%d' % $.ports.task),
    k8s.envVal('TIDEPOOL_USER_CLIENT_ADDRESS', internal(me)),
  ],

  misc(me):: [
    k8s.envVar('AWS_REGION', me.config.cluster.metadata.region),
    k8s.envVar('TIDEPOOL_ENV', 'local'),
    k9s.env.Var('TIDEPOOL_LOGGER_LEVEL', me.general.logLevel),
    k8s.envVar('TIDEPOOL_SERVER_TLS', 'false'),
    k8s.envSecret('TIDEPOOL_AUTH_SERVICE_SECRET', 'auth', 'ServiceAuth'),
    k8s.envVar('OC_AGENT_HOST', 'oc-collector.tracing:55678'),  // XXX hardcoded
  ],
}

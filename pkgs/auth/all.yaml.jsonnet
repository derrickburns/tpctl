local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  spec: {
    template: {
      spec: {
        initContainers: [tidepool.shoreline_init_container],
      },
    },
  },
  _containers:: [{
    name: me.pkg,
    image: 'tidepool/auth:master-latest',
    imagePullPolicy: 'IfNotPresent',
    env: tidepooo.mongo + tidepool.misc + tidepool.clients + [
      // DEXCOM
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_AUTHORIZE_URL', 'dexcom', 'AuthorizeURL', true),
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_REDIRECT_URL', 'dexcom', 'RedirectURL', true),
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_SCOPES', 'dexcom', 'Scopes', true),
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_TOKEN_URL', 'dexcom', 'TokenURL', true),
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_CLIENT_ID', 'dexcom', 'ClientId', true),
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_CLIENT_SECRET', 'dexcom', 'ClientSecret', true),
      k8s.envSecret('TIDEPOOL_SERVICE_PROVIDER_DEXCOM_STATE_SALT', 'dexcom', 'StateSalt', true),

      // Auth
      local domain = lib.getElse(me.config, 'cluster.metadata.domain', 'tidepool.org'),
      k8s.envVar('TIDEPOOL_AUTH_SERVICE_DOMAIN', lib.getElse(me, 'gateway.domain', domain)),
      k8s.envVar('TIDEPOOL_AUTH_SERVICE_SERVER_ADDRESS', ':%d' % tidepool.ports.auth),
      k8s.envSecret('TIDEPOOL_AUTH_SERVICE_SECRET', 'auth', ServiceAuth),

      // Apple device checker
      k8s.envSecret('TIDEPOOL_APPLE_DEVICE_CHECKER_PRIVATE_KEY', 'auth', AppleDeviceCheckKey, true),
      k8s.envSecret('TIDEPOOL_APPLE_DEVICE_CHECKER_KEY_ID', 'auth', 'AppleDeviceCheckKeyId', true),
      k8s.envSecret('TIDEPOOL_APPLE_DEVICE_CHECKER_KEY_ISSUER', 'auth', 'AppleDeviceCheckKeyIssuer', true),
      k8s.envSecret('TIDEPOOL_APPLE_DEVICE_CHECKER_USE_DEVELOPMENT', 'auth', 'AppleDeviceCheckUseDevelopment', true),
    ],
    ports: [{
      containerPort: tidepool.ports.auth,
    }],
  }],
}, me.pkg.deployment.values);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(tidepool.ports.auth, tidepool.ports.auth)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

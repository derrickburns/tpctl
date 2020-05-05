local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    image: 'tidepool/highwater:master-latest',
    env: [
      k8s.envVar('SKIP_HAKKEN', 'true'),
      k8s.envVar('DISCOVERY_HOST', 'hakken'),
      k8s.envSecret('METRICS_APIKEY', 'kissmetrics', 'APIKey', true),
      k8s.envSecret('METRICS_TOKEN', 'kissmetrics', 'Token', true),
      k8s.envSecret('METRICS_UCSF_APIKEY', 'kissmetrics', 'UCSFAPIKey', true),
      k8s.envSecret('METRICS_UCSF_WHITELIST', 'kissmetrics', 'UCSFWhitelist', true),
      k8s.envVar('NODE_ENV', tidepool.nodeEnvironment),
      k8s.envVar('PORT', tidepool.ports.highwater),
      k8s.envVar('PUBLISH_HOST', 'hakken'),
      k8s.envVar('SALT_DEPLOY', 'userdata', 'UserIdSalt'),
      k8s.envSecret('SERVER_SECRET', 'server', 'ServiceAuth'),
      k8s.envVar(
        'USER_API_SERVICE', std.manifestJson(
          {
            type: 'static',
            hosts: [{ protocol: 'http', host: 'shoreline:%s' % tidepool.ports.shoreline }],
          }
        )
      ),
    ],
    ports: [{
      containerPort: tidepool.ports.highwater,
    }],
    livenessProbe: {
      httpGet: {
        path: '/status',
        port: tidepool.ports.highwater,
      },
      initialDelaySeconds: 3,
      periodSeconds: 10,
    },
  },
}, me.deployment.values);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(tidepool.ports.export, tidepool.ports.export)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

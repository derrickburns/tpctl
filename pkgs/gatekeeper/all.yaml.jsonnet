local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    image: 'tidepool/gatekeeper:master-latest',
    env: me.tidepool.mongo + [
      k8s.envVar('TIDEPOOL_STORE_DATABASE', 'gatekeeper'),
      k8s.envVar('DISCOVERY_HOST', 'hakken'),
      k8s.envSecret('GATEKEEPER_SECRET', 'userdata', 'GroupIdEncryptionKey'),
      k8s.envVar('NODE_ENV', tidepool.nodeEnvironment),
      k8s.envVar('PORT', tidepool.ports.gatekeeper),
      k8s.envVar('PUBLISH_HOST', 'hakken'),
      k8s.envVar('SKIP_HAKKEN', 'true'),
      k8s.envSecret('SERVER_SECRET', 'server', 'ServiceAuth'),
      k8s.envVar('SERVICE_NAME', 'gatekeeper'),
      k8s.envVar('USER_API_SERVICE', std.manifestJson(
        { type: 'static', hosts: [{ protocol: 'http', host: 'shoreline:%s' % tidepool.ports.shoreline }] }
      )),
    ],
    ports: [{
      containerPort: tidepool.ports.gatekeeper,
    }],
    livenessProbe: {
      httpGet: {
        path: '/status',
        port: tidepool.ports.gatekeeper,
      },
      initialDelaySeconds: 3,
      periodSeconds: 10,
    },
  },
  spec+: {
    template+: {
      spec+: {
        initContainers: [tidepool.shoreline_init_container],
      },
    },
  },
}, me.deployment.values);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(tidepool.ports.gatekeeper, tidepool.ports.gatekeeper)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    image: 'tidepool/export:master-latest',
    env: me.tidepool.mongo + me.tidepool.misc + me.tidepool.clients + [
      k8s.envVar('TIDEPOOL_SYNC_TASK_STORE_DATABASE', "data"),
      k8s.envVar('API_HOST', 'http://internal.%s' % me.namespace),
      k8s.envVar('DEBUG_LEVEL', 'debug'),
      k8s.envVar('HTTP_PORT', '%s' % tidepool.ports.export),
      k8s.envSecret('SESSION_SECRET', 'export', 'SessionEncryptionKey'),
    ports: [{
      containerPort: tidepool.ports.export
    }],
    livenessProbe: {
      httpGet: {
        path: '/export/status',
        port: tidepool.ports.export,
      }
      initialDelaySeconds: 30,
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

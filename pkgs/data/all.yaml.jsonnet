local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    image: 'tidepool/data:master-latest',
    env: me.tidepool.mongo + me.tidepool.misc + me.tidepool.clients + [
      k8s.envSecret('TIDEPOOL_DATA_SERVICE_SECRET', 'data', 'ServiceAuth', true),
      k8s.envVar('TIDEPOOL_DATA_SERVICE_SERVER_ADDRESS', tidepool.ports.data),
      k8s.envVar('TIDEPOOL_DATA_SOURCE_CLIENT_ADDRESS', "http://data:%s" % tidepool.ports.data),
      k8s.envVar('TIDEPOOL_DEPRECATED_DATA_STORE_DATABASE', "data"),
      k8s.envVar('TIDEPOOL_SYNC_TASK_STORE_DATABASE', "data"),
    ]
    ports: [{
      containerPort: tidepool.ports.data
    }],
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
    ports: [k8s.port(tidepool.ports.data, tidepool.ports.data)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    name: me.pkg,
    image: 'tidepool/%s:master-latest' % me.pkg,,
    serviceAccountName: me.pkg.
    env: me.tidepool.mongo + me.tidepool.misc + me.tidepool.clients + [
      k8s.envSecret('TIDEPOOL_BLOB_SERVICE_SECRET', 'blob', 'ServiceAuth'),
      k8s.envVar('TIDEPOOL_BLOB_SERVICE_SERVER_ADDRESS', ':%d' % me.tidepool.ports.blob),
      k8s.envVar('TIDEPOOL_BLOB_SERVICE_UNSTRUCTURED_STORE_FILE_DIRECTORY', me.deployment.env.store.file.directory),
      k8s.envVar('TIDEPOOL_BLOB_SERVICE_UNSTRUCTURED_STORE_S3_BUCKET', me.deployment.env.store.s3.bucket),
      k8s.envVar('TIDEPOOL_BLOB_SERVICE_UNSTRUCTURED_STORE_S3_PREFIX', me.deployment.env.store.s3.prefix),
      k8s.envVar('TIDEPOOL_BLOB_SERVICE_UNSTRUCTURED_STORE_S3_TYPE', me.deployment.env.store.type),
    ]
  },
  spec: {
    template: {
      spec: {
        initContainers: [tidepool.shoreline_init_container],
      },
    },
  },
    ports: [{
      containerPort: tidepool.ports.blob,
    }],
  }],
}, me.deployment.values);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(tidepool.ports.blob, tidepool.ports.blob)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

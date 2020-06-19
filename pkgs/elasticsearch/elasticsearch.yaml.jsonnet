local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local elasticsearch(me) = k8s.k('elasticsearch.k8s.elastic.co/v1beta1', 'Elasticsearch') {
  local config = me.config,
  metadata+: {
    name: me.pkg,
    namespace: me.namespace,
  },
  spec+: {
    nodeSets: [
      {
        config: {
          'node.data': true,
          'node.ingest': true,
          'node.master': true,
          'node.store.allow_mmap': false,
        },
        count: 3,
        name: 'default',
        volumeClaimTemplates: [
          {
            metadata: {
              name: 'elasticsearch-data',
            },
            spec: {
              accessModes: [
                'ReadWriteOnce',
              ],
              resources: {
                requests: {
                  storage: lib.getElse(me, 'storage', '5Gi'),
                },
              },
              storageClassName: 'gp2-expanding',  // XXX hardcoded
            },
          },
        ],
      },
    ],
    version: '7.5.1',
  },
};

function(config, prev, namespace, pkg) elasticsearch(common.package(config, prev, namespace, pkg))

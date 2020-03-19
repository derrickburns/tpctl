local lib = import '../../lib/lib.jsonnet';

local elasticsearch(config, me) = {
  apiVersion: 'elasticsearch.k8s.elastic.co/v1beta1',
  kind: 'Elasticsearch',
  metadata: {
    name: 'jaeger',
    namespace: me.namespace,
  },
  spec: {
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
              storageClassName: 'gp2-expanding',
            },
          },
        ],
      },
    ],
    version: '7.5.1',
  },
};

function(config, prev, namespace, pkg) elasticsearch(config, lib.package(config, namespace, pkg))

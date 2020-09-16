local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '4.1.6', repository: 'https://charts.cockroachdb.com' }) {
  spec+: {
    values: {
      conf: {
        cache: '2Gi',
        'max-sql-memory': '2Gi',
      },
      statefulset: {
        resources: {
          limits: {
            memory: '8Gi',
          },
          requests: {
            memory: '8Gi',
          },
        },
      },
      tls: {
        enabled: true,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

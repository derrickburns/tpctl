local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local configmap(config, me) = k8s.configmap(me, 'cwagentconfig') {
  data: {
    'cwagentconfig.json': std.manifestJson(
      {
        agent: {
          region: config.cluster.metadata.region,
        },
        logs: {
          metrics_collected: {
            kubernetes: {
              cluster_name: config.cluster.metadata.name,
              metrics_collection_interval: 60,
            },
          },
          force_flush_interval: 15,
        },
      }
    ),
  },
};

function(config, prev, namespace, pkg) configmap(config, lib.package(config, namespace, pkg))

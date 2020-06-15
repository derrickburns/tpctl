local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local generateAccounts(me) = k8s.k('batch/v1', 'Job') + k8s.metadata('generate-accounts', me.namespace) {
  local clusterName = me.config.cluster.metadata.name,
  spec+: {
    template: {
      containers+: {
        image: 'tidepool/loadtest:latest',
        env: if global.isEnabled(me.config, 'statsd-exporter') then [
          k8s.envVar('K6_STATSD_ADDR', 'statsd-exporter.monitoring:9125'),
        ] else [],
        command: [
          'python3',
          'accountTool.py',
          'create',
          '--numAccounts',
          lib.getElse(me, 'accounts', 50,),
          '--studyID',
          clusterName,
          '--master',
          '%s+loadtest-MASTER@tidepool.org' % clusterName,
          '--env',
          clusterName,
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) generateAccounts(common.package(config, prev, namespace, pkg))

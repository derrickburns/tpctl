local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local grafanaConfig(me) = k8s.configmap(me, 'grafana-ini') {
  data: {
    'grafana.ini': std.manifestIni({
      sections: {
        'auth.anonymous': {
          org_name: 'Main Org.',
          org_role: 'Editor',
          enabled: 'true',
        },
        log: {
          mode: 'console',
        },
      },
    }),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    grafanaConfig(me),
  ]
)

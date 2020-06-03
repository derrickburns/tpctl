local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local grafanaConfig(me) = k8s.configmap(me, 'grafana-ini') {
  data: {
    'grafana.ini': std.manifestIni({
      sections: {
        users: {
          allow_sign_up: false,
          auto_assign_org: true,
          auto_assign_org_role: 'Admin',
        },
        'auth.proxy': {
          enabled: true,
          header_name: 'x-pomerium-authenticated-user-email',
          header_property: 'email',
          auto_sign_up: true,
          sync_ttl: '60',
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

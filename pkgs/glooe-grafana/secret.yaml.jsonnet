local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secret(me) = k8s.secret(me) {
  data: {
    'admin-password': 'dGlkZXBvb2w=',
    'admin-user': 'YWRtaW4=',
    'ldap-toml': '',
  },
};

function(config, prev, namespace, pkg) secret(lib.package(config, namespace, pkg))

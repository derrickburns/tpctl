local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secret(me) = k8s.secret(me) {
  data: {
    GRAFANA_PASSWORD: 'dGlkZXBvb2w=',
    GRAFANA_USERNAME: 'YWRtaW4=',
  },
};

function(config, prev, namespace, pkg) secret(common.package(config, prev, namespace, pkg))

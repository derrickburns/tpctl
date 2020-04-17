local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local upstream(me) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata(me.pkg, me.namespace) {
  spec+: {
    static: {
      hosts: [
        {
          addr: '%s.%s.svc.cluster.local' % [ me.pkg, me.namespace ],
          port: 8080,
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) upstream(common.package(config, prev, namespace, pkg))

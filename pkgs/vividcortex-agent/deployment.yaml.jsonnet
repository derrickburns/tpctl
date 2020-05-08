local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: lib.getElse(me, 'image', 'pazaan/vc-agent:latest'),
    local domain = lib.getElse(me, 'cluster.metadata.domain', 'tidepool.org'),
    env: [
      k8s.envSecret('VC_API_TOKEN', 'vividcortex', 'APIToken'),
      k8s.envVar('VC_HOSTNAME', lib.getElse(me, 'gateway.apiHost', lib.getElse(me, 'gateway.host', '%s.%s' % [me.namespace, domain]))),
      k8s.envVar('VC_DRV_MANUAL_QUERY_CAPTURE', 'slow-log'),
      k8s.envSecret('VC_DRV_MANUAL_HOST_URI', 'vividcortex', 'HostURI'),
    ],
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

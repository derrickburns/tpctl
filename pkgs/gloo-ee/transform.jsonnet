local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local kustomize  = import '../../lib/kustomize.jsonnet';

local patch(me, proxy) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: proxy,
    namespace: me.namespace,
  },
  spec: {
    template: {
      spec: {
        securityContext: {
          sysctls: [
            {
              name: 'net.netfilter.nf_conntrack_tcp_timeout_close_wait',
              value: '10',
            },
          ],
        },
      },
    },
  },
};

local addnamespace(me) = std.map(kustomize.namespace(me.namespace), me.prev);

local transform(me) = 
  k8s.patch( 
    k8s.patch(
      k8s.patch(
        k8s.asMap(addnamespace(me)),
        patch(me, 'gateway-proxy')), 
      patch(me, 'internal-gateway-proxy')), 
    patch(me, 'pomerium-gateway-proxy'));


function(config, prev, namespace, pkg) addnamespace(common.package(config, prev, namespace, pkg))

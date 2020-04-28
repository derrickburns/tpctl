local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local kustomize  = import '../../lib/kustomize.jsonnet';
local buddies  = import '../../lib/buddies.jsonnet';

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

local sysctl(me, proxy) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata+: {
    name: proxy,
    namespace: me.namespace,
  },
  spec+: {
    template+: {
      spec+: {
        initContainers+: [ buddies.sysctl ]
      },
    },
  },
};

local addnamespace(me) = std.map(kustomize.namespace(me.namespace), me.prev);

local transform(me) = 
  k8s.asMap(addnamespace(me)) +
  k8s.asMap(sysctl(me, 'gateway-proxy')) +  // XXX hardcoded
  k8s.asMap(sysctl(me, 'internal-gateway-proxy')) + 
  k8s.asMap(sysctl(me, 'pomerium-gateway-proxy'));

function(config, prev, namespace, pkg) transform(common.package(config, prev, namespace, pkg))

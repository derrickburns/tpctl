local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local kustomize  = import '../../lib/kustomize.jsonnet';
local buddies  = import '../../lib/buddies.jsonnet';

local linkerd(me) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Settings',
  metadata: {
    name: 'default',
    namespace: me.namespace,
  },
  spec+: {
    linkerd: global.isEnabled(me.config, 'linkerd'),
    gateway: {
     readGatewaysFromAllNamespaces: true
    }
  }
};

local gatewayAnnotations(me) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'gateway',
    namespace: me.namespace,
  },
  spec+ {
    template+: {
      metadata+: {
        annotations+: {
          'linkerd.io/inject': 'disabled',
        },
      },
    },
  }
};

local glooAnnotations(me) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'gloo',
    namespace: me.namespace,
  },
  spec+ {
    template+: {
      metadata+: {
        annotations+: {
          'linkerd.io/inject': 'disabled',
        },
      },
    },
  }
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
  k8s.asMap(sysctl(me, 'pomerium-gateway-proxy')) +
  k8s.asMap(linkerd(me)) +
  k8s.asMap(gatewayAnnotations(me)) +
  k8s.asMap(glooAnnotations(me));

function(config, prev, namespace, pkg) transform(common.package(config, prev, namespace, pkg))

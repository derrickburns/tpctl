local buddies = import '../../lib/buddies.jsonnet';
local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local kustomize = import '../../lib/kustomize.jsonnet';

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
      readGatewaysFromAllNamespaces: true,
    },
  },
};

local gatewayAnnotations(me) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata+: {
    name: 'gateway',
    namespace: me.namespace,
  },
  spec+: {
    template+: {
      metadata+: {
        annotations+: {
          'linkerd.io/inject': 'disabled',
        },
      },
    },
  },
};

local glooAnnotations(me) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata+: {
    name: 'gloo',
    namespace: me.namespace,
  },
  spec+: {
    template+: {
      metadata+: {
        annotations+: {
          'linkerd.io/inject': 'disabled',
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
        initContainers+: [buddies.sysctl],
      },
    },
  },
};

local addnamespace(me) = std.map(kustomize.namespace(me.namespace), me.prev);

local extauthDeployment(me) = k8s.findMatch(me.prev, {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata+: {
    name: 'extauth',
    namespace: me.namespace,
  },
});

local patchExtauthContainer(container) = (
  if !std.objectHas(container, 'name') || container.name != 'extauth' then container else
    container {
      command: ['/bin/sh'],
      args: ['-c', 'sleep 10 && /usr/local/bin/extauth'],
    }
);

local patchExtauthContainers(deployment) = (
  local containers = deployment.spec.template.spec.containers;
  deployment {
    spec+: {
      template+: {
        spec+: {
          containers: std.map(patchExtauthContainer, containers),
        },
      },
    },
  }
);

local extauth(me) = (
  local deployment = extauthDeployment(me);
  if k8s.isResource(deployment) then patchExtauthContainers(deployment) else []
);

local transform(me) =
  k8s.asMap(addnamespace(me)) +
  k8s.asMap(linkerd(me)) +
  k8s.asMap(extauth(me));
// k8s.asMap(gatewayAnnotations(me)) +
// k8s.asMap(glooAnnotations(me));

function(config, prev, namespace, pkg) transform(common.package(config, prev, namespace, pkg))

local global = import '../../lib/global.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local serviceprofile(me) = {
  apiVersion: 'linkerd.io/v1alpha2',
  kind: 'ServiceProfile',
  metadata: {
    name: 'pomerium-proxy.%s.svc.cluster.local' % me.namespace,
    namespace: me.namespace
  },
  spec: {
    routes: [
      {
        condition: {
          pathRegex: '/.*',
        },
        name: '/all',
        timeout: '90s',
      },
    ],
  },
};

function(config, prev, namespace, pkg) serviceprofile(common.package(config, prev, namespace, pkg))

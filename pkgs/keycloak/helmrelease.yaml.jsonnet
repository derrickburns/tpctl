local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me, { version:'8.2.2', repository: 'https://codecentric.github.io/helm-charts' }) {
    spec+: {
      values+: {
        keycloak: {
          image: {
            tag: '10.0.1',
          },
          password: 'admin',
        },
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

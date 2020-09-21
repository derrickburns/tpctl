local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me { chart: { name: 'example-idp' } }, { version: '0.4.0', repository: 'https://k8s.ory.sh/helm/charts' }) {
    spec+: {
      values+: {
        hydraAdminUrl: 'http://hydra-admin.%s:4445' % me.namespace,
        hydraPublicUrl: 'https://hydra.%s' % me.config.cluster.metadata.domain,
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

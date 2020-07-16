local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me + { chart: { name: 'example-idp' } }, { version:'0.4.0', repository: 'https://k8s.ory.sh/helm/charts' }) {
    spec+: {
      values+: {
        hydraAdminUrl: 'http://hydra-admin.hydra:4445',
        hydraPublicUrl: 'https://hydra.dev.tidepool.org',
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

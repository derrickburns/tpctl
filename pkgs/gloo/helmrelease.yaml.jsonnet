local gloo = import '../../lib/gloo.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  local version = lib.getElse(me, 'version', '1.3.17');
  k8s.helmrelease(me, { version: version, repository: 'https://storage.googleapis.com/solo-public-helm' }) {
    spec+: {
      values: gloo.globalValues(me, version) + gloo.glooValues(me, version),
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

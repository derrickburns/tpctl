local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = (
  local version = lib.getElse(me, 'version', '1.3.15');
  k8s.helmrelease('gloo', me.namespace, version, 'https://storage.googleapis.com/solo-public-helm') {
    spec+: {
      values: gloo.globalValues(config, me, version) + gloo.glooValues(config, me, version)
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))

local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, me) = (
  local version = lib.getElse(me, 'version', '1.3.0-beta6');
  k8s.helmrelease('gloo', me.namespace, version, 'http://storage.googleapis.com/gloo-ee-helm') {
    spec+: {
      values: gloo.globalValues(config, me, version) + { gloo: gloo.glooValues(config, me, version) }
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))

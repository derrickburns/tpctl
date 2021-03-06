local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me, { version: version, repository: 'https://storage.googleapis.com/solo-public-helm' }) {
    spec+: {
      values: gloo.globalValues(me) + gloo.glooValues(me),
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

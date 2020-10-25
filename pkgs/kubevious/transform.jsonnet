local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local kustomize = import '../../lib/kustomize.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata+: {
    name: 'kubevious-svc',
    namespace: me.namespace,
  },
  spec+: {
    type: 'ClusterIP',
  },
};

local uiService(me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata+: {
    name: 'kubevious-ui-svc',
    namespace: me.namespace,
  },
  spec+: {
    type: 'ClusterIP',
  },
};

local addnamespace(me) = std.map(kustomize.namespace(me.namespace), me.prev);

local transform(me) =
  k8s.asMap(addnamespace(me)) +
  k8s.asMap(service(me)) + 
  k8s.asMap(uiService(me));

function(config, prev, namespace, pkg) transform(common.package(config, prev, namespace, pkg))

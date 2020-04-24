local global = import '../../lib/global.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) =  (
  local config = me.config;
  k8s.helmrelease(me, { version: '1.1.0', repository: 'https://code-chris.github.io/helm-charts' }) {
    spec+: {
      values: {
        metrics: {
          enabled: global.isEnabled(config, 'prometheus-operator'),
        },
      },
    },
  });

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me, { version: '7.14.7', repository: 'https://charts.bitnami.com/bitnami' }) {
    spec+: {
      values: {
        metrics: {
          serviceMonitor: {
            enabled: global.isEnabled(me.config, 'prometheus-operator'),
          },
        },
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

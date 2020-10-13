local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me, { version: '9.2.4', repository: 'https://charts.bitnami.com/bitnami' }) {
    spec+: {
      values: {
        metrics: if global.isEnabled(me.config, 'kube-prometheus-stack') then {
          enabled: true,
          serviceMonitor: {
            enabled: true,
            namespace: global.package(me.config, 'kube-prometheus-stack').namespace,
          },
        } else {},
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

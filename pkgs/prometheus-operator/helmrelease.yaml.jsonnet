local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';

local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '8.12.7' }) {
  spec+: {
    values+: {
      grafana: lib.getElse(me, 'grafana', { enabled: false }),
      alertmanager: lib.getElse(me, 'alertmanager', { enabled: false }),
      prometheus: lib.getElse(me, 'prometheus', { enabled: true }),
      prometheusOperator: {
        admissionWebhooks: {
          enabled: false,
          patch: {
            enabled: false,
          },
        },
        tlsProxy: {
          enabled: false,
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, common.package(config, prev, namespace, pkg))

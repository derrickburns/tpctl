local common = import '../../lib/common.jsonnet';

local helmrelease() = 
  self._k8s.helmrelease(self.me, { version: '1.1.0', repository: 'https://code-chris.github.io/helm-charts' }) {
    spec+: {
      values: {
        metrics: {
          enabled: $._global.isEnabled($._config, 'prometheus-operator'),
        },
      },
    },
  };

function(config, prev, namespace, pkg) common.init(config, prev, namespace, pkg) + helmrelease()

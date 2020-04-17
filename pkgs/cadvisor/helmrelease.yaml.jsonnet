local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(it) = 
  it._k8s.helmrelease(it._me, { version: '1.1.0', repository: 'https://code-chris.github.io/helm-charts' }) {
    spec+: {
      values: {
        metrics: {
          enabled: it._global.isEnabled(it._config, 'prometheus-operator'),
        },
      },
    },
  };

function(config, prev, namespace, pkg) helmrelease(common.init(config, prev, namespace, pkg))

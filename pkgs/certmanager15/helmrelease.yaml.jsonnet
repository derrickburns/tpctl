local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = (

   local k8sVersion = lib.getElse(config, 'cluster.metadata.version', 'auto');
   local name =
     if k8sVersion == 'auto' || std.substr(k8sVersion, 0, 4) == '1.14'
     then 'cert-manager-legacy'
     else 'cert-manager';

   k8s.helmrelease(name, namespace, 'v0.14.0',
    'https://charts.jetstack.io') { 
  spec+: {
    values+: {
      prometheus: {
        enabled: lib.getElse( config, 'pkgs.prometheus.enabled', false),
        servicemonitors: {
          enabled: lib.getElse( config, 'pkgs.prometheusOperator.enabled', false),
        },
      },
    },
  },
});

function(config, prev, namespace) helmrelease(config, namespace)

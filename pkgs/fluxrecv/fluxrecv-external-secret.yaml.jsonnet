local lib = import '../../lib/lib.jsonnet';
local es = import '../external-secrets/lib.jsonnet';

function(config, prev) (
  local namespace = lib.getElse(config, 'pkgs.fluxrecv.namespace', 'flux');
  es.externalSecret(config, 
    (if lib.isTrue(config, 'pkgs.fluxrecv.sidecar') 
     then 'fluxrecv-config'
     else 'fluxrecv-config-separate'
    ),
    namespace)
)

local es = import '../external-secrets/lib.jsonnet';

function(config, prev) (
  local namespace = lib.getElse(config, 'pkgs.fluxrecv.namespace', 'flux');
  es.externalSecret(config, 'fluxrecv-config', namespace)
)

local lib = import '../../lib/lib.jsonnet';

function(config, prev) (
  local pkg = config.pkgs.fluxrecv;
  if lib.isTrue(pkg, 'spec.values.ingress.service.http.enabled')
  then lib.virtualService('fluxrecv', pkg.namespace, pkg.spec.values.ingress, 'http')
  else {}
)

local lib = import '../../lib/lib.jsonnet';

function(config) (
  local pkg = config.pkgs.fluxrecv;
  if lib.isTrue(pkg, 'spec.values.ingress.service.https.enabled')
  then lib.virtualService('fluxrecv', pkg.namespace, pkg.spec.values.ingress, "https")
  else {}
)

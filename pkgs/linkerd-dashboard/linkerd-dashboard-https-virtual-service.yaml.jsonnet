local lib = import '../../lib/lib.jsonnet';

function(config,prev) (
  local pkg = config.pkgs["linkerd-dashboard"];
  if lib.isTrue(pkg, 'spec.values.ingress.service.https.enabled')
  then lib.virtualService('linkerd-dashboard', pkg.namespace, pkg.spec.values.ingress, 'https')
  else {}
)

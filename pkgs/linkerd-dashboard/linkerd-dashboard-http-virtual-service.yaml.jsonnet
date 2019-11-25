local lib = import '../../lib/lib.jsonnet';

function(config, prev) (
  local pkg = config.pkgs.linkerd-dashboard;
  if lib.isTrue(pkg, 'spec.values.ingress.service.http.enabled')
  then lib.virtualService('linkerd-dashboard', pkg.namespace, pkg.spec.values.ingress, 'http')
  else {}
)

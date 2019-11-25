local lib = import '../../lib/lib.jsonnet';

function(config, prev)
  if lib.isTrue(config, 'pkgs.linkerd-dashboard.spec.values.ingress.service.https.enabled')
  then lib.certificate(config.pkgs.linkerd-dashboard.spec.values.ingress, 'linkerd')
  else {}

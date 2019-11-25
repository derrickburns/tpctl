local lib = import '../../lib/lib.jsonnet';

function(config, prev)
  if lib.isTrue(config, 'pkgs.fluxrecv.spec.values.ingress.service.https.enabled')
  then lib.certificate(config.pkgs.fluxrecv.spec.values.ingress, 'flux')
  else {}

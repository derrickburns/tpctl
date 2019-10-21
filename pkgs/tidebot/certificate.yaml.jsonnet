local lib = import '../../lib/lib.jsonnet';

function(config)
  if lib.isTrue(config, 'pkgs.tidebot.ingress.service.https.enabled')
  then lib.certificate(config, 'tidebot')
  else {}

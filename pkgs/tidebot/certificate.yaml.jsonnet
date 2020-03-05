local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace)
  if lib.isTrue(config.namespaces[namespace], 'tidebot.spec.values.ingress.service.https.enabled')
  then lib.certificate(config.namespaces[namespace].tidebot.spec.values.ingress, 'tidebot') // XXX there is no such func
  else {}

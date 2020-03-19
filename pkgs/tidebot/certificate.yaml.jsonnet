local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) (
  local me = lib.package(config, namespace, pkg);
  if lib.isTrue(me, 'spec.values.ingress.service.https.enabled')
  then lib.certificate(me.spec.values.ingress, 'tidebot')  // XXX there is no such func
  else {}
)

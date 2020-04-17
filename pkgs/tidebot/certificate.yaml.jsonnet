local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.isTrue(me, 'spec.values.ingress.service.https.enabled')
  then lib.certificate(me.spec.values.ingress, 'tidebot')  // XXX there is no such func
  else {}
)

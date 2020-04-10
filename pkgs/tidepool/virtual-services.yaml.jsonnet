local gloo = import '../../lib/gloo.jsonnet';

local expand = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg) (
  gloo.virtualServicesForPackage(expand.expand(config), 'tidepool', namespace)
)

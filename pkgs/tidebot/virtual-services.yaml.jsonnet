local gloo = import '../../lib/gloo.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg)
  std.manifestYamlStream(gloo.virtualServicesForPackage(exp.expandConfig(config), 'tidebot', namespace))

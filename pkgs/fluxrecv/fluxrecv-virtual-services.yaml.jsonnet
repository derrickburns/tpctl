local gloo = import '../../lib/gloo.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev)
  std.manifestYamlStream(gloo.virtualServicesForPackage(exp.expandConfig(config), 'fluxrecv'))

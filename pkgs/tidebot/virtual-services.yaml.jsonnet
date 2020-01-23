local lib = import '../../lib/lib.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev)
  std.manifestYamlStream(lib.virtualServicesForPackage(exp.expandConfig(config), 'tidebot'))

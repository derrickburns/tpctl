local lib = import '../../lib/lib.jsonnet';

local expand = import '../../lib/expand.jsonnet';

function(config, prev, namespace) 
  std.manifestYamlStream( lib.virtualServicesForEnvironment(expand.expandConfig(config), namespace))

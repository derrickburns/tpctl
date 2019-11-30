local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace)
  std.manifestYamlStream( lib.virtualServicesForEnvironment(lib.expandConfig(config), namespace))

local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace)
   std.manifestYamlStream( lib.certificatesForEnvironment(lib.expandConfig(config), namespace))

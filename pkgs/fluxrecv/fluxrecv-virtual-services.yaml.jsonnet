local lib = import '../../lib/lib.jsonnet';

function(config, prev)
  std.manifestYamlStream(lib.virtualServicesForPackage(config, 'fluxrecv'))

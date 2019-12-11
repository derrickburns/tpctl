local lib = import '../../lib/lib.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev)
  std.manifestYamlStream(lib.certificatesForPackage(exp.expandConfig(config), 'fluxrecv'))

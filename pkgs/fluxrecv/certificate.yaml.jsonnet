local gloo = import '../../lib/gloo.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev)
  std.manifestYamlStream(gloo.certificatesForPackage(exp.expandConfig(config), 'fluxrecv'))

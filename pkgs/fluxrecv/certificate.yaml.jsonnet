local gloo = import '../../lib/gloo.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg)
  std.manifestYamlStream(gloo.certificatesForPackage(exp.expand(config), 'fluxrecv', namespace))

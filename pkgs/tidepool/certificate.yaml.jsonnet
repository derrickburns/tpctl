local gloo = import '../../lib/gloo.jsonnet';

local expand = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg)
  std.manifestYamlStream(gloo.certificatesForPackage(expand.expand(config), 'tidepool', namespace))

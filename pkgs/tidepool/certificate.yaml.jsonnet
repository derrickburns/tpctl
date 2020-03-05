local gloo = import '../../lib/gloo.jsonnet';

local expand = import '../../lib/expand.jsonnet';

function(config, prev, namespace)
   std.manifestYamlStream( gloo.certificatesForPackage(expand.expandConfig(config), 'tidepool', namespace))

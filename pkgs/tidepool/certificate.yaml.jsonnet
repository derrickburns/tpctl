local gloo = import '../../lib/gloo.jsonnet';
local common = import '../../lib/common.jsonnet';

local expand = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg)
  gloo.certificatesForPackage(expand.expand(config), 'tidepool', namespace)

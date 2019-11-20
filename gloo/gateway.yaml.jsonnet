local lib = import '../lib/lib.jsonnet';
local utils = import 'gateway-utils.jsonnet';

function(config) utils.gateway(config, "http", false)

local lib = import '../lib/lib.jsonnet';

function(config) lib.gateway(config, "http", false)

local lib = import 'lib/lib.jsonnet';

function(config, prev) lib.service(config, 'fluxrecv')

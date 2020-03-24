local lib = import '../../lib/lib.jsonnet';
local mylib = import '../../lib/policy.jsonnet';

local policy(me) = mylib.policyAndMetadata(me.pkg, me.namespace, mylib.withEmailPolicy());

function(config, namespace) policy(lib.package(config, namespace, 'tidepool'))

local lib = import '../../lib/lib.jsonnet';
local tplib = import 'lib.jsonnet';
local mylib = import 'policy-lib.jsonnet';

local withEmailPolicy(me) =
  {
    attachPolicy+: {
      Statement+: [
        {
          Effect: 'Allow',
          Action: 'ses:*',
          Resource: '*',
        },
      ],
      Version: '2012-10-17',
    },
  };

local policy(config, me) = (
  mylib.policyAndMetadata(
    'hydrophone',
    me.namespace,
    withEmailPolicy(me)
  )
);

function(config, namespace) policy(config, lib.package(config, namespace, 'tidepool'))

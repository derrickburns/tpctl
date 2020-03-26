local iam = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local policy(config, me) = iam.metadata(me.pkg, me.namespace) + {
  attachPolicy: {
    Statement: {
      Effect: 'Allow',
      Action: [
        'logs:*',
        's3:GetObject',
      ],
      Resource: [
        'arn:aws:logs:%s:%s:*' % [config.cluster.metadata.region, config.aws.accountNumber],
        'arn:aws:s3:::*',
      ],
    },
    Version: '2012-10-17',
  },
};

function(config, namespace, pkg) policy(config, lib.package(config, namespace, pkg))

local iam = import '../../lib/k8s.jsonnet';

local policy(config, namespace) = iam.metadata('fluentd', namespace) + {
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

function(config, namespace) policy(config, namespace)

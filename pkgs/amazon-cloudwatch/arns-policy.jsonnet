local iam = import '../../lib/iam.jsonnet';

local policy(namespace) = iam.metadata('cloudwatch-agent', namespace) + {
  attachPolicyARNs: [
    'arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy',
    'arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess',
  ]
};

function(config, namespace) policy(namespace)

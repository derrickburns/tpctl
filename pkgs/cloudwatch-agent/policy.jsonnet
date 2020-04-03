local iam = import '../../lib/k8s.jsonnet';

local policy(namespace) = iam.metadata('cloudwatch-agent', namespace) + {
  attachPolicyARNs: [
    'arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy',
    'arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess',
  ],
};

function(config, namespace, pkg) policy(namespace)

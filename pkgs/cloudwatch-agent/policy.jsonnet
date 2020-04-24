local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(namespace) = p.policy() + k8s.metadata('cloudwatch-agent', namespace) + {
  attachPolicyARNs: [
    'arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy',
    'arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess',
  ],
};

function(config, prev, namespace, pkg) policy(namespace)

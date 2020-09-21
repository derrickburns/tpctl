local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(namespace) = p.policy() + k8s.metadata('cluster-autoscaler', namespace) + p.attachPolicy(
  [
    p.statement('*', [
      'autoscaling:DescribeAutoScalingGroups',
      'autoscaling:DescribeAutoScalingInstances',
      'autoscaling:DescribeLaunchConfigurations',
      'autoscaling:DescribeTags',
      'autoscaling:SetDesiredCapacity',
      'autoscaling:TerminateInstanceInAutoScalingGroup',
    ]),
  ]
);

function(config, prev, namespace, pkg) policy(namespace)

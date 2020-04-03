local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(namespace) = k8s.metadata('cluster-autoscaler', namespace) + p.attachPolicy(
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

function(config, namespace, pkg) policy(namespace)

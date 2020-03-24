local iam = import '../../lib/k8s.jsonnet';

local policy(namespace) = iam.metadata('cluster-autoscaler', namespace) + {
  attachPolicy: {
    Statement: [
      {
        Action: [
          'autoscaling:DescribeAutoScalingGroups',
          'autoscaling:DescribeAutoScalingInstances',
          'autoscaling:DescribeLaunchConfigurations',
          'autoscaling:DescribeTags',
          'autoscaling:SetDesiredCapacity',
          'autoscaling:TerminateInstanceInAutoScalingGroup',
        ],
        Effect: 'Allow',
        Resource: '*',
      },
    ],
    Version: '2012-10-17',
  },
};

function(config, namespace, pkg) policy(namespace)

local iam = import '../../lib/iam.jsonnet';

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

function(config, namespace) policy(namespace)

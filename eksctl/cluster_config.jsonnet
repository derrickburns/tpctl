// Generate eksctl ClusterConfig file with IAM policies and service accounts

local lib = import '../lib/lib.jsonnet';

local values(obj) = [obj[field] for field in std.objectFields(obj)];

local metadata(serviceAccountName, namespace) = {
  metadata: {
    labels: {
      'aws-usage': serviceAccountName + '-service',
    },
    name: serviceAccountName,
    namespace: namespace,
  },
};

local clusterAutoscalerRole = metadata('cluster-autoscaler', 'kube-system') + {
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

local certManagerRole = metadata('cert-manager', 'cert-manager') + {
  attachPolicy: {
    Statement: [
      {
        Action: [
          'route53:ChangeResourceRecordSets',
        ],
        Effect: 'Allow',
        Resource: 'arn:aws:route53:::hostedzone/*',
      },
      {
        Action: [
          'route53:GetChange',
          'route53:ListHostedZones',
          'route53:ListResourceRecordSets',
          'route53:ListHostedZonesByName',
        ],
        Effect: 'Allow',
        Resource: '*',
      },
    ],
    Version: '2012-10-17',
  },
};

local cloudWatchRole = metadata('cloudwatch-agent', 'amazon-cloudwatch') + {
  attachPolicyARNs: [
    'arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy',
    'arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess',
  ],
};

local fluentdRole = metadata('fluentd', 'amazon-cloudwatch') + {
  attachPolicyARNs: [
    'arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy',
    'arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess',
  ],
};

local externalDNSRole = {
  attachPolicy: {
    Statement: [
      {
        Action: [
          'route53:ChangeResourceRecordSets',
        ],
        Effect: 'Allow',
        Resource: 'arn:aws:route53:::hostedzone/*',
      },
      {
        Action: [
          'route53:GetChange',
          'route53:ListHostedZones',
          'route53:ListResourceRecordSets',
          'route53:ListHostedZonesByName',
        ],
        Effect: 'Allow',
        Resource: '*',
      },
    ],
    Version: '2012-10-17',
  },
  metadata: {
    labels: {
      'aws-usage': 'DNS-alias-creation',
    },
    name: 'external-dns',
    namespace: 'external-dns',
  },
};

local dataBucket(config, namespace) = 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace];
local assetBucket(config, namespace) = 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace];

local withBucketWritingPolicy(config, env, bucket) = {
  attachPolicy+: {
    Statement+: [
      {
        Effect: 'Allow',
        Action: 's3:ListBucket',
        Resource: 'arn:aws:s3:::%s' % bucket,
      },
      {
        Effect: 'Allow',
        Action: [
          's3:GetObject',
          's3:PutObject',
          's3:DeleteObject',
        ],
        Resource: 'arn:aws:s3:::%s/*' % bucket,
      },
    ],
    Version: '2012-10-17',
  },
};


local withBucketReadingPolicy(config, env, bucket) = {
  attachPolicy+: {
    Statement+: [
      {
        Effect: 'Allow',
        Action: 's3:ListBucket',
        Resource: 'arn:aws:s3:::%s' % bucket,
      },
      {
        Effect: 'Allow',
        Action: [
          's3:GetObject',
        ],
        Resource: 'arn:aws:s3:::%s/*' % bucket,
      },
    ],
    Version: '2012-10-17',
  },
};

local withSESPolicy() = {
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

local secretsManagerServiceAccount(config) = {
  local this = self,
  iam+: {
    serviceAccounts+: [
      {
        attachPolicy: {
          Statement: [
            {
              Effect: 'Allow',
              Action: 'secretsmanager:GetSecretValue',
              Resource: 'arn:aws:secretsmanager:%s:%s:secret:%s/*' % [this.metadata.region, config.aws.accountNumber, this.metadata.name],
            },
          ],
          Version: '2012-10-17',
        },
        metadata: {
          labels: {
            'aws-usage': 'secrets-management',
          },
          name: 'external-secrets',
          namespace: 'external-secrets',
        },
      },
    ],
  },
};

local policyAndAccount(accountName, namespace, policy) = {
  iam+: {
    serviceAccounts+: [
      policy + metadata(accountName, namespace),
    ],
  },
};

local blobServiceAccount(config, env, namespace) = (
  local bucket = lib.getElse(env, 'tidepool.buckets.data', dataBucket(config, namespace));
  policyAndAccount('blob', namespace, withBucketWritingPolicy(config, env, bucket))
);

local imageServiceAccount(config, env, namespace) = (
  local bucket = lib.getElse(env, 'tidepool.buckets.data', dataBucket(config, namespace));
  policyAndAccount('image', namespace, withBucketWritingPolicy(config, env, bucket))

);
local jellyfishServiceAccount(config, env, namespace) = (
  local bucket = lib.getElse(env, 'tidepool.buckets.data', dataBucket(config, namespace));
  policyAndAccount('jellyfish', namespace, withBucketWritingPolicy(config, env, bucket))
);

local hydrophoneServiceAccount(config, env, namespace) = (
  local bucket = lib.getElse(env, 'tidepool.buckets.asset', assetBucket(config, namespace));
  policyAndAccount(
    'hydrophone',
    namespace,
    withBucketReadingPolicy(config, env, bucket) + withSESPolicy()
  )
);

local annotatedNodegroup(config, ng, clusterName) =
  ng {
    tags+: {
      'k8s.io/cluster-autoscaler/enabled': 'true',
      ['k8s.io/cluster-autoscaler/' + clusterName]: 'true',
    },
  };

local withAnnotatedNodeGroups(config) = {
  local nodeGroups = config.cluster.nodeGroups,
  nodeGroups: [annotatedNodegroup(config, ng, config.cluster.metadata.name) for ng in nodeGroups],
};

local exampleConfig = {
  aws: {
    accountNumber: '118346523422',
  },
  environments: {
    qa1: {
      gitops: {
        branch: 'develop',
      },
      buckets: {
        // data: "tidepool-test-qa1-data",
        // asset: "tidepool-test-qa1-asset"
      },
    },
  },
  cluster+: {
    metadata+: {
      name: 'test',
    },
    vpc: {
      cidr: '10.47.0.0/16',
    },
    nodeGroups: [
      {
        desiredCapacity: 4,
        instanceType: 'm5.large',
        maxSize: 5,
        minSize: 1,
        name: 'ng',
      },
    ],
  },
};

local envServiceAccounts(config, env, namespace) =
  blobServiceAccount(config, env, namespace) +
  imageServiceAccount(config, env, namespace) +
  jellyfishServiceAccount(config, env, namespace) +
  hydrophoneServiceAccount(config, env, namespace);

local tidepoolServiceAccounts(config) = (
  local mapper(key, value) = envServiceAccounts(config, value, key);
  std.foldl(function(acc, x) acc + x, values(std.mapWithKey(mapper, config.environments)), {})
);


local defaultClusterConfig = {
  apiVersion: 'eksctl.io/v1alpha5',
  kind: 'ClusterConfig',
  metadata+: {
    region: 'us-west-2',
    version: '1.14',
  },
  iam+: {
    serviceAccounts+: [
      //clusterAutoscalerRole,
      //certManagerRole,
      cloudWatchRole,
      externalDNSRole,
      fluentdRole,
    ],
    withOIDC: true,
  },
};

local all(config) =
  defaultClusterConfig
  {
    metadata+: config.cluster.metadata,
    cloudWatch+: config.cluster.cloudWatch,
    vpc+: lib.getElse(config, 'cluster.vpc', {}),
    nodeGroups+: config.cluster.nodeGroups,
    iam+: lib.getElse(config, 'cluster.iam', {}),
  } +
  withAnnotatedNodeGroups(config) +
  secretsManagerServiceAccount(config) +
  tidepoolServiceAccounts(config);

function(config) all(config)

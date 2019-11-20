local lib = import '../../lib/lib.jsonnet';

local defaultHost(env) = (
  if env.ingress.gateway.default.protocol == 'http'
  then env.ingress.gateway.http.dnsNames[0]
  else env.ingress.gateway.https.dnsNames[0]
);

local dataBucket(config, namespace) = 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace];
local assetBucket(config, namespace) = 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace];

local prefixAnnotations(prefix, svcs) = {
  ['%s.fluxcd.io/%s' % [prefix, svc]]: '%s.deployment.image' % svc
  for svc in svcs
};

local filterAnnotations(env, svcs) = {
  local default = lib.getElse(env, 'gitops.default', 'glob:develop-*'),
  ['fluxcd.io/tag.%s' % svc]: lib.getElse(env, 'gitops.%s' % svc, default)
  for svc in svcs
};

local tidepool(config, prev, namespace) = {
  local env = config.environments[namespace].tidepool,

  local svcs = [
    'auth',
    'blip',
    'blob',
    'data',
    'export',
    'gatekeeper',
    'highwater',
    'hydrophone',
    'image',
    'jellyfish',
    'messageapi',
    'migrations',
    'notification',
    'seagull',
    'shoreline',
    'task',
    'tidewhisperer',
    'tools',
    'user',
  ],

  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
                   'fluxcd.io/automated': 'true',
                 } + filterAnnotations(env, svcs)
                 + prefixAnnotations('repository', svcs),
    name: 'tidepool',
    namespace: namespace,
  },
  local tp = config.environments[namespace].tidepool,
  local common = {
    podAnnotations: {
      'config.linkerd.io/proxy-cpu-request': '0.2',
      'cluster-autoscaler.kubernetes.io/safe-to-evict': 'true',
    },
    resources: {
      requests: {
        memory: lib.getElse(tp, 'resources.requests.memory', '64Mi'),
        cpu: lib.getElse(tp, 'resources.requests.cpu', '50m'),
      },
      limits: {
        memory: lib.getElse(tp, 'resources.limits.memory', '128Mi'),
        cpu: lib.getElse(tp, 'resources.limits.cpu', '100m'),
      },
    },
    hpa: lib.getElse(tp, 'hpa', { enabled: false }),
    deployment+: {
      replicas: lib.getElse(tp, 'deployment.replicas', 1),
    },
  },

  spec: {
    rollback: {
      enable: true,
      force: true,
    },
    chart: {
      git: 'git@github.com:tidepool-org/development',
      path: lib.getElse(tp, 'chart.path', 'charts/tidepool/0.1.7'),
      ref: lib.getElse(tp, 'chart.ref', 'develop'),
    },
    releaseName: 'tidepool-%s' % namespace,
    values: {

      auth: lib.mergeList([ common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.auth.deployment.image', 'tidepool/platform-auth:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'auth', {})]),

      blip: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.blip.deployment.image', 'tidepool/blip:release-1.23.0-264f7ad48eb7d8099b00dce07fa8576f7068d0a0'),
        },
      }, lib.getElse(tp, 'blip', {})]),

      blob: lib.mergeList([common, {
        serviceAccount: {
          name: 'blob',
        },
        securityContext: {
          fsGroup: 65534,  // To be able to read Kubernetes and AWS token files
        },
        deployment+: {
          env: {
            store: {
              s3: {
                bucket: lib.getElse(tp, 'buckets.data', dataBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.blob.deployment.image', 'tidepool/platform-blob:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'blob', {})]),

      data: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.data.deployment.image', 'tidepool/platform-data:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
          replicas: 3,
        },
      }, lib.getElse(tp, 'data', {})]),

      dexcom: lib.getElse(tp, 'dexcom', {}),

      export: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
            cpu: '1000m',
          },
        },
        deployment+: {
          replicas: 3,
          image: lib.getElse(prev, 'spec.values.export.deployment.image', 'tidepool/export:develop-ddc5f311a4bdc2adae1b423f13e047ff1828d65c'),
        },
      }, lib.getElse(tp, 'export', {})]),

      gatekeeper: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '64Mi',
            cpu: '500m',
          },
          limits: {
            memory: '128Mi',
            cpu: '1000m',
          },
        },
        deployment+: {
          replicas: 2,
          image: lib.getElse(prev, 'spec.values.gatekeeper.deployment.image', 'tidepool/gatekeeper:develop-6a0e3e6d83552ce378b21d76354973dcb95c9fa1'),
        },
      }, lib.getElse(tp, 'gatekeeper', {})]),

      global: {
        logLevel: config.logLevel,
        gateway: {
          default: {
            host: defaultHost(env),
            domain: env.ingress.gateway.default.domain,
            protocol: env.ingress.gateway.default.protocol,
          },
        },
        store: {
          type: 's3',
        },
      },

      gloo: {
        enabled: false,
      },

      highwater: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.highwater.deployment.image', 'tidepool/highwater:develop-cb0ef1425b29f0a37c10e975876804f3ccfb1348'),
        },
      }, lib.getElse(tp, 'highwater', {})]),

      hydrophone: lib.mergeList([common, {
        serviceAccount: {
          name: 'hydrophone',
        },
        securityContext: {
          fsGroup: 65534,  // To be able to read Kubernetes and AWS token files
        },
        deployment+: {
          env: {
            store: {
              s3: {
                bucket: lib.getElse(tp, 'buckets.asset', assetBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.hydrophone.deployment.image', 'tidepool/hydrophone:develop-0683c6ba2c75ffd21ac01cd577acfeaf5cd0ef8f'),
        },
      }, lib.getElse(tp, 'hydrophone', {})]),

      image: lib.mergeList([common, {
        serviceAccount: {
          name: 'image',
        },
        securityContext: {
          fsGroup: 65534,  // To be able to read Kubernetes and AWS token files
        },
        deployment+: {
          env: {
            store: {
              s3: {
                bucket: lib.getElse(tp, 'buckets.data', dataBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.image.deployment.image', 'tidepool/platform-image:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'image', {})]),

      ingress: {
        certificate: env.ingress.certificate,
        deployment+: env.ingress.deployment,
        gateway: env.ingress.gateway,
        service: env.ingress.service,
      },

      jellyfish: lib.mergeList([common, {
        serviceAccount: {
          name: 'jellyfish',
        },
        securityContext: {
          fsGroup: 65534,  // To be able to read Kubernetes and AWS token files
        },
        deployment+: {
          replicas: 3,
          env: {
            store: {
              s3: {
                bucket: lib.getElse(tp, 'buckets.data', dataBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.jellyfish.deployment.image', 'tidepool/jellyfish:mongo-database-a8b117f07c277dfae78a6b5f270f84cd661b3b8d'),
        },
      }, lib.getElse(tp, 'jellyfish', {})]),

      messageapi: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.messageapi.deployment.image', 'tidepool/message-api:develop-48e4e55d3119bd94c25fa7f01be79be85a860528'),
        },
      }, lib.getElse(tp, 'messageapi', {})]),

      migrations: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.migrations.deployment.image', 'tidepool/platform-migrations:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'migrations', {})]),

      mongodb: {
        enabled: env.mongodb.enabled,
      },

      nosqlclient: {
        enabled: env.nosqlclient.enabled,
      },

      notification: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.notification.deployment.image', 'tidepool/platform-notification:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'notification', {})]),

      seagull: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.seagull.deployment.image', 'tidepool/seagull:develop-f5b583382cc468657710b15836eafad778817f7c'),
        },
      }, lib.getElse(tp, 'seagull', {})]),

      shoreline: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.shoreline.deployment.image', 'tidepool/shoreline:develop-51f927083ba5bad0271add644728e02902d3b785'),
        },
      }, lib.getElse(tp, 'shoreline', {})]),

      task: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.task.deployment.image', 'tidepool/platform-task:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'task', {})]),

      tidepool: {
        namespace: {
          create: false,
        },
      },

      tidewhisperer: lib.mergeList([common, {
        deployment+: {
          replicas: 3,
          image: lib.getElse(prev, 'spec.values.tidewhisperer.deployment.image', 'tidepool/tide-whisperer:develop-3d9d8e6b3417c70679ec43420f2a5e4a69cf9098'),
        },
      }, lib.getElse(tp, 'tidewhisperer', {})]),

      tools: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.tools.deployment.image', 'tidepool/platform-tools:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'tools', {})]),

      user: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.user.deployment.image', 'tidepool/platform-user:develop-cebea363931570d3930848a21e6a3d07a54f4425'),
        },
      }, lib.getElse(tp, 'users', {})]),

    },
  },
};

function(config, prev, namespace) tidepool(config, prev, namespace)

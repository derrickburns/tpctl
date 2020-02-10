local lib = import '../../lib/lib.jsonnet';
local expand = import '../../lib/expand.jsonnet';
local mylib = import 'lib.jsonnet';

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

local helmrelease(config, prev, namespace) = {
  local env = mylib.tpFor(config, namespace), 

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
                   'fluxcd.io/automated': if lib.getElse(env, 'gitops.enabled', true) then "true" else "false"
                 } + filterAnnotations(env, svcs)
                 + prefixAnnotations('repository', svcs),
    name: 'tidepool',
    namespace: namespace,
  },
  local common = {
    podAnnotations: {
      //'config.linkerd.io/proxy-cpu-request': '0.2',
      'cluster-autoscaler.kubernetes.io/safe-to-evict': 'true',
    },
    resources: {
      requests: {
        memory: lib.getElse(env, 'resources.requests.memory', '64Mi'),
        cpu: lib.getElse(env, 'resources.requests.cpu', '50m'),
      },
      limits: {
        memory: lib.getElse(env, 'resources.limits.memory', '128Mi'),
      },
    },
    hpa: lib.getElse(env, 'hpa', { enabled: false }),
    deployment+: {
      replicas: lib.getElse(env, 'deployment.replicas', 1),
    }
  },

spec: {
    rollback: {
      enable: true,
      force: true,
    },
    chart: if std.objectHas(env, 'chart') && std.objectHas(env.chart, 'version') then {
      repository: lib.getElse(env.chart, 'repository', 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master/'),
      name: lib.getElse(env.chart, 'name', 'tidepool'),
      version: env.chart.version
    } else  {
      git: lib.getElse(env, 'chart.git', 'git@github.com:tidepool-org/development'),
      path: lib.getElse(env, 'chart.path', 'charts/tidepool'),
      ref: lib.getElse(env, 'chart.ref', 'master'),
    },
    releaseName: 'tidepool-%s' % namespace,
    values: {

      auth: lib.mergeList([ common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.auth.deployment.image', 'tidepool/platform-auth:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'auth', {})]),

      blip: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.blip.deployment.image', 'tidepool/blip:master-47c8b1b3f298583684fe323ab170dfe7cc968902'),
        },
	      }, lib.getElse(env, 'blip', {})]),

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
                bucket: lib.getElse(env, 'buckets.data', dataBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.blob.deployment.image', 'tidepool/platform-blob:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'blob', {})]),

      data: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
          },
        },
        deployment+: {
          image: lib.getElse(prev, 'spec.values.data.deployment.image', 'tidepool/platform-data:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
          replicas: 3,
        },
      }, lib.getElse(env, 'data', {})]),

      dexcom: lib.getElse(env, 'dexcom', {}),

      export: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
          },
        },
        deployment+: {
          replicas: 3,
          image: lib.getElse(prev, 'spec.values.export.deployment.image', 'tidepool/export:release-1.4.0-133dc134dce5c287e26caafbdb6871e69fc10150'),
        },
      }, lib.getElse(env, 'export', {})]),

      gatekeeper: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
          },
        },
        deployment+: {
          replicas: 2,
          image: lib.getElse(prev, 'spec.values.gatekeeper.deployment.image', 'tidepool/gatekeeper:master-03ab418230def26a638664bfbfd0a49736c96aa3'),
        },
      }, lib.getElse(env, 'gatekeeper', {})]),

      glooingress: {
        enabled: true,
        discovery: {
          namespace: 'gloo-system',
        },
        virtualServices: {
          'http': {
            name: "http-internal",
            dnsNames: mylib.genDnsNames(config, namespace),
            enabled: true,
            labels: {
              protocol: 'http',
              type: 'internal',
              namespace: namespace,
            },
            options: {
              stats: {
                virtualClusters: lib.getElse(env,'virtualClusters', []),
              },
            },
          },
          https: {
            enabled: false
          },
        },
      },
      global: {
        local domain = lib.getElse(config, 'cluster.metadata.domain', 'tidepool.org'),
        logLevel: lib.getElse(config, 'logLevel', 'info'),
        gateway: {
          proxy: {
            name: "internal-gateway-proxy",
            namespace: "gloo-system",
          },
          default:  {
	    host: lib.getElse(env, 'gateway.host', '%s.%s' % [  namespace, domain ]),
            protocol: lib.getElse(env, 'gateway.protocol', 'https'),
            domain: lib.getElse(env, 'gateway.domain', domain),
          }
        },
        maxTimeout: lib.getElse(env, 'maxTimeout', '120s'),
        store: {
          type: 's3',
        },
      },

      gloo: {
        enabled: false,
      },

      highwater: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.highwater.deployment.image', 'tidepool/highwater:master-8db30b8b1e4ca759e8377de4a09dd9a6f6a5ce88'),
        },
      }, lib.getElse(env, 'highwater', {})]),

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
                bucket: lib.getElse(env, 'buckets.asset', assetBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.hydrophone.deployment.image', 'tidepool/hydrophone:master-8537584fb9633995c36e2df333e9709f94b30095'),
        },
      }, lib.getElse(env, 'hydrophone', {})]),

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
                bucket: lib.getElse(env, 'buckets.data', dataBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.image.deployment.image', 'tidepool/platform-image:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'image', {})]),

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
                bucket: lib.getElse(env, 'buckets.data', dataBucket(config, namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.jellyfish.deployment.image', 'tidepool/jellyfish:master-737f1009a70fd3856e08c9b858ab86752a181b1d'),
        },
      }, lib.getElse(env, 'jellyfish', {})]),

      linkerdsupport: {
        serviceProfiles: {
          enabled: lib.getElse(config, 'pkgs.linkerd.enabled', false),
        },
      },

      messageapi: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.messageapi.deployment.image', 'tidepool/message-api:master-73e5dc0b12f03bc0ec1428cde45520317dbf4688'),
        },
      }, lib.getElse(env, 'messageapi', {})]),

      migrations: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
          },
        },
        deployment+: {
          image: lib.getElse(prev, 'spec.values.migrations.deployment.image', 'tidepool/platform-migrations:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'migrations', {})]),

      mongodb: {
        enabled: lib.isTrue(env, 'mongodb.enable'),
      },

      nosqlclient: {
        enabled: lib.isTrue(env, 'nosqlclient.enabled'),
      },

      notification: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.notification.deployment.image', 'tidepool/platform-notification:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'notification', {})]),

      seagull: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
          },
        },
        deployment+: {
          image: lib.getElse(prev, 'spec.values.seagull.deployment.image', 'tidepool/seagull:master-0ac202bfccc0994d264b5fe9fcc06d2a56c55977'),
        },
      }, lib.getElse(env, 'seagull', {})]),

      shoreline: lib.mergeList([common, {
        priorityClassName: "high-priority",
        deployment+: {
          image: lib.getElse(prev, 'spec.values.shoreline.deployment.image', 'tidepool/shoreline:master-66e766fffb4058781a24740b6a809bb12e2d08a9'),
        },
      }, lib.getElse(env, 'shoreline', {})]),

      task: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.task.deployment.image', 'tidepool/platform-task:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'task', {})]),

      tidepool: {
        namespace: {
          create: false,
        },
      },

      tidewhisperer: lib.mergeList([common, {
        resources: {
          requests: {
            memory: '256Mi',
            cpu: '500m',
          },
          limits: {
            memory: '256Mi',
          },
        },
        deployment+: {
          replicas: 3,
          image: lib.getElse(prev, 'spec.values.tidewhisperer.deployment.image', 'tidepool/tide-whisperer:master-d64636a94823ceb329ade5ff8e0a7716a5108fef'),
        },
      }, lib.getElse(env, 'tidewhisperer', {})]),

      tools: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.tools.deployment.image', 'tidepool/platform-tools:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'tools', {})]),

      user: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.user.deployment.image', 'tidepool/platform-user:master-8c8d9b39182b9edd9bafd987f50b254470840a8d'),
        },
      }, lib.getElse(env, 'users', {})]),

    },
  },
};

function(config, prev, namespace) helmrelease(expand.expandConfig(config), prev, namespace)

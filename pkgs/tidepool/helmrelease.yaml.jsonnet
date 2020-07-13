local buddies = import '../../lib/buddies.jsonnet';
local common = import '../../lib/common.jsonnet';
local expand = import '../../lib/expand.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local mylib = import 'lib.libjsonnet';

local jwks(me) = {
  jwt: {
    providers: {
      'tidepool-provider': {
        issuer: me.gateway.apiHost,
        audiences: [me.gateway.apiHost],
        tokenSource: {
          headers: [{
            header: 'x-tidepool-session-token',
            prefix: '',
          }],
        },
        keepToken: true,
        claimsToHeaders: [{
          claim: 'sub',
          header: 'x-tidepool-userid',
          append: false,
        }, {
          claim: 'svr',
          header: 'x-tidepool-isServer',
          append: false,
        }],
        jwks: {
          remote: {
            upstream_ref: {
              name: 'jwks',
              namespace: me.namespace,
            },
            url: 'http://jwks.%s/jwks.json' % me.namespace,
          },
        },
      },
    },
  },
};

local dataBucket(config, namespace) = 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace];
local assetBucket(config, namespace) = 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace];
local virtualBucket(config, bucket) = bucket;

local prefixAnnotations(prefix, svcs) = {
  ['%s.fluxcd.io/%s' % [prefix, svc]]: '%s.deployment.image' % svc
  for svc in svcs
};

local filterAnnotations(me, svcs) = {
  local default = lib.getElse(me, 'gitops.default', 'regex:^master-[0-9A-Fa-f]{40}$'),
  ['fluxcd.io/tag.%s' % svc]: lib.getElse(me, 'gitops.%s' % svc, default)
  for svc in svcs
};

local proxyContainers = [{
  name: 'mongoproxy',
  image: 'tidepool/mongoproxy:latest',
  imagePullPolicy: 'Always',
  ports: [{
    containerPort: 27017,
  }],
  env: [
    {
      name: 'MONGO_SCHEME',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Scheme',
        },
      },
    },
    {
      name: 'MONGO_ADDRESSES',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Addresses',
        },
      },
    },
    {
      name: 'MONGO_USERNAME',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Username',
        },
      },
    },
    {
      name: 'MONGO_PASSWORD',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Password',
        },
      },
    },
    {
      name: 'MONGO_DATABASE',
      valueFrom: {
        secretKeyRef: {
          name: 'mongo',
          key: 'Database',
        },
      },
    },
    {
      name: 'MONGO_OPT_PARAMS',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'OptParams',
        },
      },
    },
    {
      name: 'MONGO_TLS',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Tls',
        },
      },
    },
    {
      name: 'MONGOPROXY_TIMEOUT',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Timeout',
        },
      },
    },
    {
      name: 'MONGOPROXY_READONLY',
      valueFrom: {
        secretKeyRef: {
          name: 'mongoproxy',
          key: 'Readonly',
        },
      },
    },
    {
      name: 'MONGOPROXY_PORT',
      value: '27017',
    },
  ],
}];

local svcs = [
  'auth',
  'blip',
  'blob',
  'data',
  'devices',
  'export',
  'gatekeeper',
  'highwater',
  'hydrophone',
  'image',
  'jellyfish',
  'messageapi',
  'migrations',
  'notification',
  'prescription',
  'seagull',
  'shoreline',
  'task',
  'tidewhisperer',
  'tools',
  'user',
];

local annotations(me) =
  { 'fluxcd.io/automated': if lib.getElse(me, 'gitops.enabled', true) then 'true' else 'false' }
  + filterAnnotations(me, svcs)
  + prefixAnnotations('repository', svcs);

local helmrelease(me) = k8s.helmrelease(me, {
  repository: 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master/',
  git: 'git@github.com:tidepool-org/development',
  path: 'charts/tidepool',
}) {
  local prev = k8s.findMatch(me.prev, self),
  local config = me.config,

  metadata+: {
    annotations+: annotations(me),
  },
  local common = {
    podAnnotations: linkerd.annotations(me, true) + {
      'cluster-autoscaler.kubernetes.io/safe-to-evict': 'true',  // XXX
    },
    initContainers: [buddies.sysctl],
    securityContext: k8s.securityContext,
    serviceMonitor: {
      enabled: global.isEnabled(me.config, 'prometheus-operator'),
    },
    podSecurityContext: {
      allowPrivilegeEscalation: false,
      capabilities: {
        add: [
          'NET_BIND_SERVICE',
        ],
        drop: [
          'ALL',
        ],
      },
      readOnlyRootFilesystem: true,
      runAsNonRoot: true,
      runAsUser: 65534,
    },
    hpa: lib.getElse(me, 'hpa', { enabled: false }),
    deployment+: {
      replicas: lib.getElse(me, 'deployment.replicas', 1),
    },
  },

  spec+: {
    rollback+: {
      enable: true,
      force: true,
      retry: true,
      maxRetries: 0,
    },
    releaseName: 'tidepool-%s' % me.namespace,
    values+: {
      //local extraContainers = if lib.isEnabledAt(me, 'shadow') && (lib.getElse(me, "shadow.sender", "") != "") then proxyContainers else [],
      local extraContainers = [],

      auth: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.auth.deployment.image', 'tidepool/platform-auth:master-latest'),
        },
        resources: {
          requests: {
            cpu: '40m',
          },
          limits: {
            memory: '225Mi',
            cpu: '60m',
          },
        },
      }, lib.getElse(me, 'auth', {})]),

      blip: lib.mergeList([common, {
        deployment+: {
          image: lib.getElse(prev, 'spec.values.blip.deployment.image', 'tidepool/blip:master-latest'),
        },
        resources: {
          requests: {
            memory: 'Mi',
            cpu: '30m',
          },
          limits: {
            memory: '125Mi',
            cpu: '48m',
          },
        },
      }, lib.getElse(me, 'blip', {})]),

      blob: lib.mergeList([common, {
        extraContainers: extraContainers,
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
                bucket: virtualBucket(config, lib.getElse(me, 'buckets.data', dataBucket(config, me.namespace))),
              },
              type: 's3',
            },
          },
          image: lib.getElse(prev, 'spec.values.blob.deployment.image', 'tidepool/platform-blob:master-latest'),
        },
      }, lib.getElse(me, 'blob', {})]),

      data: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.data.deployment.image', 'tidepool/platform-data:master-latest'),
          replicas: 3,
        },
      }, lib.getElse(me, 'data', {})]),

      devices: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.devices.deployment.image', 'tidepool/devices:master-latest'),
          replicas: 0,
        },
      }, lib.getElse(me, 'devices', {})]),

      dexcom: lib.getElse(me, 'dexcom', {}),

      export: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          replicas: 3,
          image: lib.getElse(prev, 'spec.values.export.deployment.image', 'tidepool/export:release-1.4.0-133dc134dce5c287e26caafbdb6871e69fc10150'),
        },
      }, lib.getElse(me, 'export', {})]),

      gatekeeper: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          replicas: 2,
          image: lib.getElse(prev, 'spec.values.gatekeeper.deployment.image', 'tidepool/gatekeeper:master-latest'),
        },
      }, lib.getElse(me, 'gatekeeper', {})]),

      glooingress: lib.merge({
        virtualServices+: {
          http+: {
            jwt: {
              enabled: lib.isEnabledAt(me, 'jwks'),
              config: jwks(me),
            },
            name: 'http-internal',
            dnsNames: mylib.genDnsNames(config, me.namespace),
            enabled: true,
            labels: {
              protocol: 'http',
              type: 'internal',
              namespace: me.namespace,
            },
            options: {
              stats: {
                virtualClusters: lib.getElse(me, 'virtualClusters', []),
              },
            },
          },
          https: {
            enabled: false,
          },
        },
      }, lib.getElse(me, 'glooingress', {})),

      global: {
        local domain = lib.getElse(config, 'cluster.metadata.domain', 'tidepool.org'),
        logLevel: lib.getElse(config, 'general.logLevel', 'info'),

        linkerdsupport: {
          enabled: global.isEnabled(config, 'linkerd'),
        },

        gateway: {
          proxy: {
            name: 'internal-gateway-proxy',
            namespace: 'gloo-system',
          },
          default: {
            host: lib.getElse(me, 'gateway.host', '%s.%s' % [me.namespace, domain]),
            apiHost: lib.getElse(me, 'gateway.apiHost', lib.getElse(me, 'gateway.host', '%s.%s' % [me.namespace, domain])),
            appHost: lib.getElse(me, 'gateway.appHost', lib.getElse(me, 'gateway.host', '%s.%s' % [me.namespace, domain])),
            protocol: lib.getElse(me, 'gateway.protocol', 'https'),
            domain: lib.getElse(me, 'gateway.domain', domain),
          },
        },
        maxTimeout: lib.getElse(me, 'maxTimeout', '120s'),
        region: lib.getElse(config, 'cluster.metadata.region', 'us-west-2'),
        store: {
          type: 's3',
        },
      },

      highwater: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.highwater.deployment.image', 'tidepool/highwater:master-latest'),
        },
      }, lib.getElse(me, 'highwater', {})]),

      hydrophone: lib.mergeList([common, {
        extraContainers: extraContainers,
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
                bucket: lib.getElse(me, 'buckets.asset', assetBucket(config, me.namespace)),
              },
            },
            type: 's3',
          },
          image: lib.getElse(prev, 'spec.values.hydrophone.deployment.image', 'tidepool/hydrophone:master-latest'),
        },
      }, lib.getElse(me, 'hydrophone', {})]),

      image: lib.mergeList([common, {
        extraContainers: extraContainers,
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
                bucket: virtualBucket(config, lib.getElse(me, 'buckets.data', dataBucket(config, me.namespace))),
              },
              type: 's3',
            },
          },
          image: lib.getElse(prev, 'spec.values.image.deployment.image', 'tidepool/platform-image:master-latest'),
        },
      }, lib.getElse(me, 'image', {})]),

      jellyfish: lib.mergeList([common, {
        extraContainers: extraContainers,
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
                bucket: virtualBucket(config, lib.getElse(me, 'buckets.data', dataBucket(config, me.namespace))),
              },
              type: 's3',
            },
          },
          image: lib.getElse(prev, 'spec.values.jellyfish.deployment.image', 'tidepool/jellyfish:master-latest'),
        },
      }, lib.getElse(me, 'jellyfish', {})]),

      messageapi: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.messageapi.deployment.image', 'tidepool/message-api:master-latest'),
        },
      }, lib.getElse(me, 'messageapi', {})]),

      migrations: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          replicas: 0,
          image: lib.getElse(prev, 'spec.values.migrations.deployment.image', 'tidepool/platform-migrations:master-latest'),
        },
      }, lib.getElse(me, 'migrations', {})]),

      mongodb: {
        enabled: lib.isEnabledAt(me, 'mongodb'),
      },

      notification: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.notification.deployment.image', 'tidepool/platform-notification:master-latest'),
        },
      }, lib.getElse(me, 'notification', {})]),

      prescription: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          env: {
            store: {
              s3: {
                bucket: lib.getElse(me, 'buckets.asset', assetBucket(config, me.namespace)),
              },
            },
          },
          replicas: 0,
          image: lib.getElse(prev, 'spec.values.prescription.deployment.image', 'tidepool/platform-prescription:update-prescriptions-1245451dd04adba59d7483796ca8a5672b142f8c'),
        },
      }, lib.getElse(me, 'prescription', {})]),

      seagull: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.seagull.deployment.image', 'tidepool/seagull:master-latest'),
        },
      }, lib.getElse(me, 'seagull', {})]),

      shoreline: lib.mergeList([common, {
        extraContainers: extraContainers,
        priorityClassName: 'high-priority',
        deployment+: {
          isShadow: lib.isEnabledAt(me, 'shadow') && (lib.getElse(me, 'shadow.sender', '') != ''),
          image: lib.getElse(prev, 'spec.values.shoreline.deployment.image', 'tidepool/shoreline:master-latest'),
        },
      }, lib.getElse(me, 'shoreline', {})]),

      task: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.task.deployment.image', 'tidepool/platform-task:master-latest'),
        },
      }, lib.getElse(me, 'task', {})]),

      tidepool: {
        tests: lib.getElse(me, 'tests', {
          enabled: false,
        }),
        namespace: {
          create: false,
        },
      },

      tidewhisperer: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          replicas: 3,
          image: lib.getElse(prev, 'spec.values.tidewhisperer.deployment.image', 'tidepool/tide-whisperer:master-latest'),
        },
      }, lib.getElse(me, 'tidewhisperer', {})]),

      tools: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.tools.deployment.image', 'tidepool/platform-tools:master-latest'),
        },
      }, lib.getElse(me, 'tools', {})]),

      user: lib.mergeList([common, {
        extraContainers: extraContainers,
        deployment+: {
          image: lib.getElse(prev, 'spec.values.user.deployment.image', 'tidepool/platform-user:master-latest'),
        },
      }, lib.getElse(me, 'users', {})]),

    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

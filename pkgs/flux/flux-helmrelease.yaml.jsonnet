local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local genvalues(config, namespace) = {
  local ns = config.namespaces[namespace],
  image: {
    tag: lib.getElse(ns, 'flux.version', '1.18.0'),
  },

  helm: {
    versions: 'v3',
  },

  logFormat: 'fmt',

  sops: {
    enabled: true,
  },

  git: {
    label: config.cluster.metadata.name,
    email: config.general.email,
    url: '%s.git' % config.general.github.git,
  },

  prometheus: {
    enabled: lib.isEnabledAt(config, 'pkgs.prometheus'),
    serviceMonitor: {
      create: lib.isEnabledAt(config, 'pkgs.prometheusOperator'),
    },
  },

  sync: {
    timeout: '10m',
  },

  syncGarbageCollection: {
    enabled: true,
    dry: false,
  },

  additionalArgs: if lib.isTrue(ns, 'fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

  extraContainers:
    if lib.isEnabledAt(ns, 'fluxrecv') && lib.isTrue(ns, 'fluxrecv.sidecar')
    then [{
      name: 'recv',
      image: 'fluxcd/flux-recv:%s' % lib.getElse(ns, 'fluxrecv.version', '0.3.0'),
      imagePullPolicy: 'IfNotPresent',
      args: ['--config=/etc/fluxrecv/fluxrecv.yaml'],
      ports: [{
        containerPort: 8080,
      }],
      volumeMounts: [{
        name: 'fluxrecv-config',
        mountPath: '/etc/fluxrecv',
      }],
    }]
    else [],

  extraVolumes:
    if lib.isEnabledAt(ns, 'fluxrecv') && lib.isTrue(ns, 'fluxrecv.sidecar')
    then [{
      name: 'fluxrecv-config',
      secret: {
        secretName: 'fluxrecv-config',
        defaultMode: std.parseOctal('0400'),
      },
    }]
    else [],

  resources: {
    requests: {
      cpu: '75m',
      memory: '128Mi',
    },
  },
};

function(config, prev, namespace) k8s.helmrelease('flux', namespace, '1.2.0', 'https://charts.fluxcd.io') + { spec+: { values: genvalues(config, namespace) } }

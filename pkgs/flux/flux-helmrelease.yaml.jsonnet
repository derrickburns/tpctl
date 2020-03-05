local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local genvalues(config, namespace) = {
  image: {
    tag: lib.getElse(config.namespaces[namespace], 'flux.version', '1.18.0'),
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
    enabled: lib.isTrue(config, 'pkgs.prometheus.enabled'),
    serviceMonitor: {
      create: lib.isTrue(config, 'pkgs.prometheus.enabled'),
    },
  },

  syncGarbageCollection: {
    enabled: true,
    dry: false,
  },

  additionalArgs: if lib.isTrue(config.namespaces[namespace], 'fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

  extraContainers:
    if lib.isTrue(config.namespaces[namespace], 'fluxrecv.enabled') && lib.isTrue(config.namespaces[namespace], 'fluxrecv.sidecar')
    then [{
      name: 'recv',
      image: 'fluxcd/flux-recv:%s' % lib.getElse(config.namespaces[namespace], 'fluxrecv.version', '0.3.0'),
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
    if lib.isTrue(config.namespaces[namespace], 'fluxrecv.enabled') && lib.isTrue(config.namespaces[namespace], 'fluxrecv.sidecar')
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

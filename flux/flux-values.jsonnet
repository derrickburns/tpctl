local lib = import '../lib/lib.jsonnet';

local values(config) = {
  image: {
    tag: lib.getElse(config, 'pkgs.flux.version', '1.17.1')
  },

  logFormat: 'fmt',

  git: {
    label: config.cluster.metadata.name,
    email: config.email,
    url: '%s.git' % config.github.git,
  },

  prometheus: {
    enabled: lib.isTrue(config, 'pkgs.prometheus-operator.enabled')
    serviceMonitor: {
      create: lib.isTrue(config, 'pkgs.prometheus-operator.enabled'),
    },
  },

  syncGarbageCollection: {
    enabled: true,
    dry: false,
  },

  additionalArgs: if lib.isTrue(config, 'pkgs.fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

  extraContainers: 
    if lib.isTrue(config, 'pkgs.fluxrecv.enabled') && lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
    then [{
      name: 'recv',
      image: 'fluxcd/flux-recv:%s' % lib.getElse(config, 'pkgs.fluxrecv.version', '0.3.0'),
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
    if lib.isTrue(config, 'pkgs.fluxrecv.enabled') && lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
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

function(config) values(config)

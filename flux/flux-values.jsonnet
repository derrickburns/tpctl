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
    enabled: true,
    serviceMonitor: {
      create: true,
    },
  },

  syncGarbageCollection: {
    enabled: true,
    dry: false,
  },

  additionalArgs: if lib.isTrue(config, 'pkgs.fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

  annotations+: {
    "reloader.stakater.com/auto: "true",
  },

  extraContainers: 
    if lib.isTrue(config, 'pkgs.fluxrecv.enabled') && lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
    then [{
      name: 'recv',
      image: 'fluxcd/flux-recv:0.2.0',
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

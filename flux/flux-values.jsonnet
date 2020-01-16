local lib = import '../lib/lib.jsonnet';

local values(config) = {
  image: {
    tag: lib.getElse(config, 'pkgs.flux.version', '1.15.0')
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
    enable: true,
    dry: false,
  },

  additionalArgs: if lib.isTrue(config, 'pkgs.fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

  annotations+: {
    "secret.reloader.stakater.com/reload": 
       if lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
       then "fluxrecv-config,flux-helm-repositories"
       else "flux-helm-repositories",
  },

  extraContainers: 
    if lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
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
    if lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
    then [{
      name: 'fluxrecv-config',
      secret: {
        secretName: 'fluxrecv-config',
        defaultMode: std.parseOctal('0400'),
      },
    }]
    else [],
};

function(config) values(config)

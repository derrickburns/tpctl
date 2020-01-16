local lib = import '../lib/lib.jsonnet';

local values(config) = {

  createCRD: true,
  helm: {
    version: "v3",
  },

  prometheus: {
    enabled: true,
    serviceMonitor: {
      create: true,
    },
  },

  annotations: {
    "secret.reloader.stakater.com/reload": "flux-helm-repositories",
  },

  configureRepositories: {
    enabled: true,
    volumeName: 'repositories-yaml',
    secretName: 'flux-helm-repositories',
    cacheVolumeName: 'repositories-cache',
  },

  image: {
    tag: '1.0.0-rc7'
  },

  logReleaseDiffs: true,
};

function(config) values(config)

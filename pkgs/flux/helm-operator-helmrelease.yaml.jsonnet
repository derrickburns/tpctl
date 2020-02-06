local lib = import '../../lib/lib.jsonnet';

local genvalues(config) = {

  createCRD: false,
  helm: {
    versions: "v3",
  },

  prometheus: {
    enabled: true,
    serviceMonitor: {
      create: true,
    },
  },

  git: {
    ssh: {
      secretName: 'flux-git-deploy',
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
    repository: 'docker.io/fluxcd/helm-operator',
    tag: '1.0.0-rc8',
  },

  logReleaseDiffs: false,

  resources: {
    requests: {
      cpu: '75m',
      memory: '325Mi',
    },
  },
};

function(config, prev)
  lib.helmrelease('helm-operator', 'flux', 'https://charts.fluxcd.io', '0.6.0') { spec+: { values: genvalues(config) } }

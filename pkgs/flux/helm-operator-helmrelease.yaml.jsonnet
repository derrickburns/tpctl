local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local genvalues(config) = {

  local secretName = 'flux-helm-repositories',

  createCRD: false,
  helm: {
    versions: 'v3',
  },

  prometheus: {
    enabled: lib.isEnabledAt(config, 'pkgs.prometheus'),
    serviceMonitor: {
      create: lib.isEnabledAt(config, 'pkgs.prometheusOperator'),
    },
  },

  git: {
    ssh: {
      secretName: 'flux-git-deploy',
    },
  },

  annotations: {
    'secret.reloader.stakater.com/reload': secretName,
  },

  configureRepositories: {
    enabled: true,
    volumeName: 'repositories-yaml',
    secretName: secretName,
    cacheVolumeName: 'repositories-cache',
  },

  image: {
    repository: 'docker.io/fluxcd/helm-operator',
    tag: '1.0.0-rc9',
  },

  logReleaseDiffs: false,

  resources: {
    requests: {
      cpu: '75m',
      memory: '325Mi',
    },
  },
};

function(config, prev, namespace)
  k8s.helmrelease('helm-operator', namespace, '0.6.0', 'https://charts.fluxcd.io') { spec+: { values: genvalues(config) } }

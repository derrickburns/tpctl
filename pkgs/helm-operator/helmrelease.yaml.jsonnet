local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { name: 'helm-operator', version: '0.6.0', repository: 'https://charts.fluxcd.io' }) {
  _secretNames:: ['flux-git-deploy', 'flux-helm-repositories'],
  spec+: {
    values: {

      createCRD: false,
      helm: {
        versions: 'v3',
      },

      prometheus: {
        enabled: global.isEnabled(config, 'prometheus'),
        serviceMonitor: {
          create: global.isEnabled(config, 'prometheus-operator'),
        },
      },

      git: {
        ssh: {
          secretName: $._secretNames[0],
        },
      },

      configureRepositories: {
        enabled: true,
        volumeName: 'repositories-yaml',
        secretName: $._secretNames[1],
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
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))

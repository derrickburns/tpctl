local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'helm-operator', version: lib.getElse(me, 'version', '1.2.0'), repository: 'https://charts.fluxcd.io' }) {
  _secretNames:: ['flux-git-deploy', 'flux-helm-repositories'],
  spec+: {
    values+: {

      helm: {
        versions: 'v3',
      },

      prometheus: {
        serviceMonitor: {
          create: global.isEnabled(me.config, 'prometheus-operator'),
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

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local fluxGitDeploySecretName = 'flux-git-deploy';
local fluxHelmRepositoriesSecretName = 'flux-helm-repositories';

local helmrelease(me) = k8s.helmrelease(me,
                                        { name: 'helm-operator', version: '1.2.0', repository: 'https://charts.fluxcd.io' },
                                        secretNames=[fluxGitDeploySecretName, fluxHelmRepositoriesSecretName]) {
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
          secretName: fluxGitDeploySecretName,
        },
      },

      configureRepositories: {
        enabled: true,
        volumeName: 'repositories-yaml',
        secretName: fluxHelmRepositoriesSecretName,
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

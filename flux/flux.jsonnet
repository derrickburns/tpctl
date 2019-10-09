local updateFlux(config, deployment) = (
  local container = deployment.spec.template.spec.containers[0];

  deployment
  {
    spec+: {
      template+: {
        spec+: {
          containers: [container {
            image: 'docker.io/fluxcd/flux:1.15.0',
            args+: [
              '--sync-interval=1m',
              '--git-poll-interval=1m',
            ] + if config.pkgs.fluxcloud.enabled
            then ['--connect=ws://fluxcloud']
            else [],
          }],
        },
      },
    },
  }
);

local updateHelmOperator(deployment) = (
  local container = deployment.spec.template.spec.containers[0];
  deployment {
    spec+: {
      template+: {
        spec+: {
          volumes+: [
            {
              name: 'repositories-yaml',
              secret: {
                secretName: 'flux-helm-repositories',
              },
            },
            {
              name: 'repositories-cache',
              emptyDir: {},
            },
          ],
          containers: [
            container {
	      image: 'docker.io/fluxcd/helm-operator:1.0.0-rc2',
              volumeMounts+: [
                {
                  name: 'repositories-yaml',
                  mountPath: '/var/fluxd/helm/repository',
                },
                {
                  name: 'repositories-cache',
                  mountPath: '/var/fluxd/helm/repository/cache',
                },
              ],
            },
          ],
        },
      },
    },
  }
);

local updateTiller(deployment) = (
  local container = deployment.spec.template.spec.containers[0];

  deployment
  {
    spec+: {
      template+: {
        spec+: {
          containers: [container {
            image: 'gcr.io/kubernetes-helm/tiller:v2.14.3',
          }],
        },
      },
    },
  }
);

function(config, flux, helm, tiller) {
  flux: updateFlux(config, flux),
  helm: updateHelmOperator(helm),
  tiller: updateTiller(tiller),
}

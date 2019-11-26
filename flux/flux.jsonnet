local lib = import '../lib/lib.jsonnet';

local updateFlux(config, deployment) = (
  local container = deployment.spec.template.spec.containers[0];

  local volumes =
    if lib.isTrue(config, 'pkgs.fluxrecv.sidecar')
    then [{
      name: 'fluxrecv-config',
      secret: {
        secretName: 'fluxrecv-config',
        defaultMode: std.parseOctal('0400'),
      },
    }]
    else [];

  local sidecar =
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
    else [];

  deployment
  {
    spec+: {
      template+: {
        spec+: {
          volumes+: volumes,
          containers: [container {
            image: 'docker.io/fluxcd/flux:1.15.0',
            args+: [
              '--sync-interval=1m',
              '--git-poll-interval=1m',
            ] + if lib.isTrue(config, 'pkgs.fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],
          }] + sidecar,
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

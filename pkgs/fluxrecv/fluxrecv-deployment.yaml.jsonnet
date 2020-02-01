local lib = import '../../lib/lib.jsonnet';

local deployment(config) =
  {
    apiVersion: 'extensions/v1beta1',
    kind: 'Deployment',
    metadata: {
      annotations: {
        "secret.reloader.stakater.com/reload": "fluxrecv-config"
      },
      name: 'fluxrecv',
      namespace: lib.getElse(config, 'pkgs.fluxrecv.namespace', 'flux'),
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          name: 'fluxrecv',
        },
      },
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          labels: {
            name: 'fluxrecv',
          },
        },
        spec: {
          containers: [
            {
              name: 'recv',
              image: 'fluxcd/flux-recv:%s' % lib.getElse(config, 'pkgs.fluxrecv.version', '0.3.0'),
              imagePullPolicy: 'IfNotPresent',
              args: ['--config=/etc/fluxrecv/fluxrecv.yaml'],
              ports: [{
                containerPort: 8080,
              }],
              volumeMounts: [{
                name: 'fluxrecv-config',
                mountPath: '/etc/fluxrecv',
              }],
            },
          ],
          restartPolicy: 'Always',
          volumes: [
            {
              name: 'fluxrecv-config',
              secret: {
                secretName: 'fluxrecv-config',
                defaultMode: std.parseOctal('0400'),
              },
            },
          ],
        },
      },
    },
  };

function(config, prev) if lib.getElse(config, 'pkgs.fluxrecv.sidecar', false) then {} else deployment(config)

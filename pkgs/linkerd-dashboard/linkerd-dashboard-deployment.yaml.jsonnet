local lib = import '../../lib/lib.jsonnet';

local deployment(config) =
  {
    apiVersion: 'extensions/v1beta1',
    kind: 'Deployment',
    metadata: {
      name: 'linkerd-dashboard',
      namespace: lib.getElse(config, 'pkgs.linkerd-dashboard.namespace', 'flux'),
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          name: 'linkerd-dashboard',
        },
      },
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          labels: {
            name: 'linkerd-dashboard',
          },
        },
        spec: {
          containers: [
            {
              name: 'recv',
              image: 'fluxcd/flux-recv:0.2.0',
              imagePullPolicy: 'IfNotPresent',
              args: ['--config=/etc/linkerd-dashboard/linkerd-dashboard.yaml'],
              ports: [{
                containerPort: 8080,
              }],
              volumeMounts: [{
                name: 'linkerd-dashboard-config',
                mountPath: '/etc/linkerd-dashboard',
              }],
            },
          ],
          restartPolicy: 'Always',
          volumes: [
            {
              name: 'linkerd-dashboard-config',
              secret: {
                secretName: 'linkerd-dashboard-config',
                defaultMode: std.parseOctal('0400'),
              },
            },
          ],
        },
      },
    },
  };

function(config, prev) if lib.getElse(config, 'pkgs.linkerd-dashboard.sidecar', false) then {} else deployment(config)

local lib = import '../lib/lib.jsonnet';

local deployment(config) =
  {
    apiVersion: 'extensions/v1beta1',
    kind: 'Deployment',
    metadata: {
      name: 'fluxrecv',
      namespace: 'flux',
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

function(config) deployment(config)

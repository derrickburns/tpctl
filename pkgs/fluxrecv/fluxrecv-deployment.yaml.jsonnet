local lib = import '../../lib/lib.jsonnet';

local deployment(config, namespace) =
  {
    apiVersion: 'extensions/v1beta1',
    kind: 'Deployment',
    metadata: {
      annotations: {
        'secret.reloader.stakater.com/reload': 'fluxrecv-config',
      },
      name: 'fluxrecv',
      namespace: namespace,
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
              image: 'fluxcd/flux-recv:%s' % lib.getElse(config.namespaces[namespace], 'fluxrecv.version', '0.3.0'),
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
                secretName: (if lib.isTrue(config.namespaces[namespace], 'fluxrecv.sidecar')
     			     then 'fluxrecv-config'
     			     else 'fluxrecv-config-separate'),
                defaultMode: std.parseOctal('0400'),
              },
            },
          ],
        },
      },
    },
  };

function(config, prev, namespace) if lib.getElse(config.namespaces[namespace], 'fluxrecv.sidecar', false) then {} else deployment(config, namespace)

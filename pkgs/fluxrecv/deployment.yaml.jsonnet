local lib = import '../../lib/lib.jsonnet';

local deployment(config, me) =
  {
    local secretName =
      if lib.isTrue(me, 'sidecar')
      then 'fluxrecv-config'
      else 'fluxrecv-config-separate',
    apiVersion: 'extensions/v1beta1',
    kind: 'Deployment',
    metadata: {
      annotations: {
        'secret.reloader.stakater.com/reload': secretName,
      },
      name: me.pkg,
      namespace: me.namespace,
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          name: me.pkg,
        },
      },
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          labels: {
            name: me.pkg,
          },
        },
        spec: {
          containers: [
            {
              name: 'recv',
              image: 'fluxcd/flux-recv:%s' % lib.getElse(me, 'version', '0.4.0'),
              imagePullPolicy: 'IfNotPresent',
              args: ['--config=/etc/fluxrecv/fluxrecv.yaml'],
              ports: [{
                containerPort: 8080,
              }],
              readinessProbe: {
                httpGet: {
                  path: '/health',
                  port: 8080,
                },
              },
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
                secretName: secretName,
                defaultMode: std.parseOctal('0400'),
              },
            },
          ],
        },
      },
    },
  };

function(config, prev, namespace, pkg) (
  local me = lib.package(config, namespace, pkg);
  if lib.isTrue(me, 'sidecar')
  then {}
  else deployment(config, me)
)

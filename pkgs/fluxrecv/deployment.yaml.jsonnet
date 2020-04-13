local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(config, me) = k8s.deployment(me) {
  local secretName =
    if lib.isTrue(me, 'sidecar')
    then 'fluxrecv-config'
    else 'fluxrecv-config-separate',
  spec+: {
    template+: {
      spec+: {
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

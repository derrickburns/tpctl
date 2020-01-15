local lib = import '../../../../lib/lib.jsonnet';

local pvc(config) = {
  apiVersion: 'v1',
  kind: 'PersistentVolumeClaim',
  metadata: {
    labels: {
      app: 'glooe-prometheus',
      chart: 'prometheus-9.5.1',
      component: 'server',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-prometheus-server',
    namespace: 'gloo-system',
  },
  spec: {
    accessModes: [
      'ReadWriteOnce',
    ],
    resources: {
      requests: {
        storage: lib.getElse(config, 'pkgs.glooe-prometheus-server.storage', '32Gi')
      },
    },
    storageClassName: 'gp2-expanding',
  },
};

function(config,prev) pvc(config)

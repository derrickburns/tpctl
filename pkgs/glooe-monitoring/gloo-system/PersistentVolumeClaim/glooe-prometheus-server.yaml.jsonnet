local persistentvolumeclaim(namespace) = {
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
        storage: '64Gi',
      },
    },
    storageClassName: 'gp2-expanding',
  },
};

function(config, prev, namespace) persistentvolumeclaim(namespace)

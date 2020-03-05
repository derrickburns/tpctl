local persistentvolumeclaim(namespace) = {
  apiVersion: 'v1',
  kind: 'PersistentVolumeClaim',
  metadata: {
    labels: {
      app: 'glooe-grafana',
      chart: 'grafana-4.0.1',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-grafana',
    namespace: namespace,
  },
  spec: {
    accessModes: [
      'ReadWriteOnce',
    ],
    resources: {
      requests: {
        storage: '100Mi',
      },
    },
  },
};

function(config, prev, namespace) persistentvolumeclaim(namespace)

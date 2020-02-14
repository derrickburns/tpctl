local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config) = k8s.helmrelease('velero', 'velero', '2.8.1', 'https://vmware-tanzu.github.io/helm-charts') {
  spec+: {
    values: {
      credentials: {
        useSecret: false,
      },
      configuration: {
        provider: 'aws',
        backupStorageLocation: {
          name: 'aws',
          bucket: 'k8s-backup-%s' % config.cluster.metadata.name,
          config: {
            region: config.cluster.metadata.region,
          },
        },
        logLevel: config.general.logLevel,
        volumeSnapshotLocation: {
          name: 'velero.io/aws',
          config: {
            region: config.cluster.metadata.region,
          },
        },
        image: {
          repositoru: 'velero/velero',
          pullPolicy: 'IfNotPresent',
        },
        initContainers: [{
          name: 'velero-plugin-for-aws',
          image: 'velero/velero-plugin-for-aws:v1.0.0',
          volumeMounts: [{
            mountPath: '/target',
            name: 'plugins',
          }],
        }],
      },

      metrics: {
        serviceMonitor: {
          enabled: true,
        },
      },
    },
  },
};

function(config, prev) helmrelease(config)

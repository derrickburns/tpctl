local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'velero',
    namespace: 'velero',
  },
  spec: {
    chart: {
      name: 'velero',
      repository: 'https://vmware-tanzu.github.io/helm-charts',
      version: '2.8.1',
    },
    releaseName: 'velero',
    values: {
      credentials: {
        useSecret: false,
      },
      configuration: {
        provider: "aws",
        backupStorageLocation: {
          name: "aws",
          bucket: "k8s-backup-%s' % config.cluster.metadata.name,
          config: {
            region: config.cluster.metadata.region,
          },
        }
        logLevel: config.logLevel,
        volumeSnapshotLocation: {
           name: "velero.io/aws",
           config: {
              region: config.cluster.metadata.region,
           },
        },
        image: {
          repositoru: "velero/velero",
          pullPolicy: "IfNotPresent",
        },
        initContainers: [ {
          name: "velero-plugin-for-aws",
          image: "velero/velero-plugin-for-aws:v1.0.0",
          volumeMounts: [ {
            mountPath: "/target",
            name: "plugins",
           } ],
        } ],
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

local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, {
  name: 'velero',
  version: '2.8.1',
  chart: 'https://vmware-tanzu.github.io/helm-charts',
}) {
  spec+: {
    values: {
      credentials: {
        useSecret: false,
      },
      configuration: {
        provider: 'aws', // XXX AWS dependency
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
          repository: 'velero/velero',
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
          enabled: global.isEnabled(config, 'prometheus-operator'),
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))

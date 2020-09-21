local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, {
  name: 'velero',
  version: '2.9.13',
  repository: 'https://vmware-tanzu.github.io/helm-charts',
}) {
  spec+: {
    values+: {
      credentials: {
        useSecret: false,
      },
      configuration: {
        provider: 'aws',  // XXX AWS dependency
        backupStorageLocation: {
          name: 'aws',
          bucket: 'k8s-backup-%s' % me.config.cluster.metadata.name,
          config: {
            region: me.config.cluster.metadata.region,
          },
        },
        logLevel: me.config.general.logLevel,
        volumeSnapshotLocation: {
          name: 'velero.io-aws',
          config: {
            region: me.config.cluster.metadata.region,
          },
        },
        image: {
          repository: 'velero/velero:v1.4.0',
          pullPolicy: 'IfNotPresent',
        },
      },
      initContainers: [{
        name: 'velero-plugin-for-aws',
        image: 'velero/velero-plugin-for-aws:v1.0.1',
        volumeMounts: [{
          mountPath: '/target',
          name: 'plugins',
        }],
      }],

      metrics: {
        serviceMonitor: {
          enabled: global.isEnabled(me.config, 'prometheus-operator'),
        },
      },
      serviceAccount: {
        server: {
          create: false,
          name: me.pkg,
        },
      },
      securityContext: {
        fsGroup: 65534,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

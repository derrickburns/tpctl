local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secretName = 'thanos';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.3.29', repository: 'https://kubernetes-charts.banzaicloud.com' }) {
  local config = me.config,
  local metrics = {
    metrics: {
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
      },
    },
  },
  local affinityAndTolerations = {
    affinity: {
      nodeAffinity: k8s.nodeAffinity(),
    },
    tolerations: [k8s.toleration()],
  },
  spec+: {
    values: {
      image: {
        tag: 'v0.16.0',
      },
      bucket: {
        enabled: lib.isEnabledAt(me, 'bucket'),
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
      } + affinityAndTolerations + metrics,
      store: {
        enabled: lib.isEnabledAt(me, 'store'),
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
      } + affinityAndTolerations + metrics,
      query: {
        enabled: lib.isEnabledAt(me, 'query'),
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
      } + affinityAndTolerations + metrics,
      compact: {
        enabled: lib.isEnabledAt(me, 'compact'),
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
        resources: {
          requests: {
            cpu: '1',
            memory: '1Gi',
          },
        },
        dataVolume: {
          backend: {
            persistentVolumeClaim: {
              claimName: 'thanos-compact',
            },
          },
        },
        persistentVolumeClaim: {
          name: 'thanos-compact',
          spec: {
            storageClassName: 'monitoring-expanding',
            accessModes: ['ReadWriteOnce'],
            resources: {
              requests: {
                storage: '100Gi',
              },
            },
          },
        },
      } + affinityAndTolerations + metrics,
      sidecar: {
        enabled: lib.isEnabledAt(me, 'sidecar'),
      } + metrics,
      objstoreSecretOverride: 'thanos',
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

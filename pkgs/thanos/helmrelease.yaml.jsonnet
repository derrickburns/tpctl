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
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
      } + affinityAndTolerations + metrics,
      store: {
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
      } + affinityAndTolerations + metrics,
      query: {
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
      } + affinityAndTolerations + metrics,
      compact: {
        serviceAccount: lib.getElse(config, 'namespaces.monitoring.kube-prometheus-stack.prometheus.serviceAccount', ''),
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
      sidecar: metrics,
      objstoreSecretOverride: 'thanos',
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

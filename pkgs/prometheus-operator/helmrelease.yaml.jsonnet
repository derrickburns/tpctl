local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local affinity = {
  nodeAffinity: {
    requiredDuringSchedulingIgnoredDuringExecution: {
      nodeSelectorTerms: [{
        matchExpressions: [
          {
            key: 'role',
            operator: 'In',
            values: ['monitoring'],
          },
        ],
      }],
    },
  },
};

local tolerations = [
  {
    key: 'role',
    operator: 'Equal',
    value: 'monitoring',
    effect: 'NoSchedule',
  },
];

local helmrelease(me) = k8s.helmrelease(me, { version: '8.14.0' }) {
  spec+: {
    values+: {
      grafana: {
        enabled: lib.isEnabledAt(me, 'grafana'),
        persistence: {
          enabled: true,
          storageClassName: 'monitoring-expanding',
          size: '20Gi',
        },
        annotations: {
          'cluster-autoscaler.kubernetes.io/safe-to-evict': 'false',
        },
        env: {
          GF_PATHS_CONFIG: '/etc/grafana/grafana-config.ini',
        },
        extraConfigmapMounts: [
          {
            name: 'grafana-ini',
            mountPath: '/etc/grafana/grafana-config.ini',
            configMap: 'grafana-ini',
            subPath: 'grafana.ini',
          },
        ],
        resources: {
          limits: {
            memory: '500Mi',
          },
        },
        affinity: affinity,
        tolerations: tolerations,
      },
      alertmanager: {
        enabled: lib.isEnabledAt(me, 'alertmanager'),
        alertmanagerSpec: {
          affinity: affinity,
          tolerations: tolerations,
          retention: '240h',
        },
      },
      prometheus: {
        enabled: lib.isEnabledAt(me, 'prometheus'),
        annotations: {
          'cluster-autoscaler.kubernetes.io/safe-to-evict': 'false',
        },
        prometheusSpec: {
          ruleSelectorNilUsesHelmValues: false,
          serviceMonitorSelectorNilUsesHelmValues: false,
          podMonitorSelectorNilUsesHelmValues: false,
          enableAdminAPI: true,
          containers: [
            {
              name: 'prometheus',
              readinessProbe: {
                initialDelaySeconds: 60,
                failureThreshold: 300,
              },
            },
          ],
          resources: {
            limits: {
              memory: '12G',
            },
          },
          affinity: affinity,
          tolerations: tolerations,
          thanos: if global.isEnabled(me.config, 'thanos') then {
            image: 'quay.io/thanos/thanos:v0.12.2',
            version: 'v0.12.2',
            resources: {
              limits: {
                cpu: '0.25',
                memory: '250M',
              },
            },
            objectStorageConfig: {
              name: 'thanos',
              key: 'object-store.yaml',
            },
          } else {},
          retentionSize: '140GiB',
          retention: '90d',
          storageSpec: {
            volumeClaimTemplate: {
              metadata: {
                name: 'prometheus',
                namespace: me.namespace,
              },
              spec: {
                storageClassName: 'monitoring-expanding',
                resources: {
                  requests: {
                    storage: '150Gi',
                  },
                },
              },
            },
          },
        },
      },
      defaultRules: {
        // Not monitoring etcd, kube-scheduler, or kube-controller-manager because it is managed by EKS
        rules: {
          etcd: false,
          kubeScheduler: false,
        },
      },
      kubeControllerManager: {
        enabled: false,
      },
      kubeEtcd: {
        enabled: false,
      },
      kubeScheduler: {
        enabled: false,
      },
      prometheusOperator: {
        affinity: affinity,
        tolerations: tolerations,
        annotations: {
          'cluster-autoscaler.kubernetes.io/safe-to-evict': 'false',
        },
        admissionWebhooks: {
          enabled: false,
          patch: {
            enabled: false,
          },
        },
        tlsProxy: {
          enabled: false,
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

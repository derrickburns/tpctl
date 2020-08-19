local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '9.2.2' }) {
  spec+: {
    values+: {
      grafana: {
        enabled: lib.isEnabledAt(me, 'grafana'),
        plugins: ['grafana-piechart-panel']
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
          requests: {
            memory: '500Mi',
          },
        },
        affinity: {
          nodeAffinity: k8s.nodeAffinity(),
        },
        tolerations: [k8s.toleration()],
      },
      alertmanager: {
        enabled: lib.isEnabledAt(me, 'alertmanager'),
        alertmanagerSpec: {
          affinity: {
            nodeAffinity: k8s.nodeAffinity(),
          },
          configMaps: [
            'alertmanager-slack-template',
          ],
          configSecret: 'alertmanager-config',
          externalUrl: 'https://alertmanager.%s' % me.config.cluster.metadata.domain,
          tolerations: [k8s.toleration()],
          retention: '240h',
          storage: {
            volumeClaimTemplate: {
              metadata: {
                name: 'alertmanager',
                namespace: me.namespace,
              },
              spec: {
                storageClassName: 'monitoring-expanding',
                resources: {
                  requests: {
                    storage: '1Gi',
                  },
                },
              },
            },
          },
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
          externalUrl: 'https://prometheus.%s' % me.config.cluster.metadata.domain,
          podMonitorSelectorNilUsesHelmValues: false,
          additionalScrapeConfigsSecret: {
            enabled: lib.getElse(me, 'prometheus.additionalScrapeConfigsSecret', false),
            name: 'prometheus-operator-prometheus-additional-scrape-configs',
            key: 'scrape-configs.yaml',
          },
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
          affinity: {
            nodeAffinity: k8s.nodeAffinity(),
          },
          tolerations: [k8s.toleration()],
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
          retentionSize: lib.getElse(me, 'prometheus.retentionSize', '130GiB'),
          retention: lib.getElse(me, 'prometheus.retentionPeriod', '90d'),
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
                    storage: lib.getElse(me, 'prometheus.storageSize', '150Gi'),
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
          // breaking too often
          kubeApiserverAvailability: false,
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
      'kube-state-metrics': {
        collectors: {
          // Need K8s 1.16+
          mutatingwebhookconfigurations: false,
          validatingwebhookconfigurations: false,
          verticalpodautoscalers: true,
        },
      },
      prometheusOperator: {
        affinity: {
          nodeAffinity: k8s.nodeAffinity(),
        },
        tolerations: [k8s.toleration()],
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

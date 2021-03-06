local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '9.4.5', repository: 'https://prometheus-community.github.io/helm-charts' }) {
  local config = me.config,
  spec+: {
    values+: {
      grafana: {
        enabled: lib.isEnabledAt(me, 'grafana'),
        plugins: ['grafana-piechart-panel'],
        persistence: {
          enabled: true,
          storageClassName: 'monitoring-expanding',
          size: lib.getElse(me, 'grafana.storageSize', '1Gi'),
        },
        annotations: {
          'cluster-autoscaler.kubernetes.io/safe-to-evict': 'false',
        },
        sidecar: {
          dashboards: {
            searchNamespace: 'ALL',
          },
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
        resources: lib.getElse(
          me, 'grafana.resources', {
            requests: {
              memory: '500Mi',
            },
          },
        ),
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
        serviceAccount: {
          create: !lib.isEnabledAt(me, 'prometheus.thanos.sidecar'),
          name: lib.getElse(me, 'prometheus.serviceAccount', ''),
        },
        prometheusSpec: {
          ruleSelectorNilUsesHelmValues: false,
          serviceMonitorSelectorNilUsesHelmValues: false,
          externalUrl: 'https://prometheus.%s' % config.cluster.metadata.domain,
          image: {
            tag: 'v2.22.1',
          },
          podMonitorSelectorNilUsesHelmValues: false,
          externalLabels: {
            region: config.cluster.metadata.region,
            cluster: config.cluster.metadata.name,
          },
          additionalScrapeConfigsSecret: {
            enabled: lib.getElse(me, 'prometheus.additionalScrapeConfigsSecret', false),
            name: 'kube-prometheus-stack-prometheus-additional-scrape-configs',
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
            // Prometheus-operator does not support 1-off settings like uploading compacted blocks
            // but you can overwrite the containers as below
            if lib.isEnabledAt(me, 'prometheus.thanos.sidecar') && lib.getElse(me, 'prometheus.thanos.sidecar.uploadCompacted', false) then
              {
                name: 'thanos-sidecar',
                args: [
                  // Default sidecar args
                  'sidecar',
                  '--prometheus.url=http://127.0.0.1:9090/',
                  '--tsdb.path=/prometheus',
                  '--grpc-address=[$(POD_IP)]:10901',
                  '--http-address=[$(POD_IP)]:10902',
                  '--objstore.config=$(OBJSTORE_CONFIG)',
                  '--log.level=info',
                  '--log.format=logfmt',
                  // Upload already compacted blocks
                  '--shipper.upload-compacted',
                ],
              },
          ],
          resources: lib.getElse(me, 'prometheus.resources', {
            limits: {
              memory: '12G',
            },
          }),
          affinity: {
            nodeAffinity: k8s.nodeAffinity(),
          },
          tolerations: [k8s.toleration()],
          thanos: if lib.isEnabledAt(me, 'prometheus.thanos.sidecar') then {
            version: 'v0.16.0',
            resources: if lib.getElse(me, 'prometheus.thanos.sidecar.uploadCompacted', false) then {
              requests: {
                cpu: '1',
                memory: '1.5G',
              },
            } else {
              requests: {
                cpu: '0.5',
                memory: '1G',
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
        image: {
          tag: 'v0.38.2',
        },
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

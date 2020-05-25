local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '8.12.7' }) {
  spec+: {
    values+: {
      grafana: lib.getElse(me, 'grafana', {
        enabled: true,
        persistence: {
          enabled: true,
          existingClaim: 'grafana',
        },
        env: {
          GF_PATHS_CONFIG: '/etc/grafana/grafana-config.ini',
          GF_SECURITY_ADMIN_PASSWORD: 'tidepool',
        },
        extraConfigmapMounts: [
          {
            name: 'grafana-ini',
            mountPath: '/etc/grafana/grafana-config.ini',
            configMap: 'grafana-ini',
            subPath: 'grafana.ini',
          },
        ],
      }),
      alertmanager: lib.getElse(me, 'alertmanager', { enabled: false }),
      prometheus: lib.getElse(
        me,
        'prometheus',
        {
          enabled: true,
          prometheusSpec: {
            serviceMonitorSelectorNilUsesHelmValues: false,
            podMonitorSelectorNilUsesHelmValues: false,
            enableAdminAPI: true,
            resources: {
              requests: {
                memory: '5000M',
              },
              limits: {
                memory: '7000M',
              },
            },
            thanos: {
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
            },
            retentionSize: '140GiB',
            retention: '30d',
            storageSpec: {
              volumeClaimTemplate: {
                metadata: {
                  name: 'prometheus',
                  namespace: me.namespace,
                },
                spec: {
                  storageClassName: 'gp2-expanding',
                  resources: {
                    requests: {
                      storage: '150Gi',
                    },
                  },
                },
              },
            },
          },
        }
      ),
      prometheusOperator: {
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

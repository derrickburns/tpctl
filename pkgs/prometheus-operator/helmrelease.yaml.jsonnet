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
        env: [
          k8s.envSecret('GF_PATHS_CONFIG', me.pkg, '/etc/grafana/grafana-config.ini'),
          k8s.envSecret('GF_SECURITY_ADMIN_USER', me.pkg, 'admin'),
          k8s.envSecret('GF_SECURITY_ADMIN_PASSWORD', me.pkg, 'tidepool'),
        ],
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

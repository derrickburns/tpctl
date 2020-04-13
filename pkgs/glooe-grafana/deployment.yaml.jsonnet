local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    strategy+: {
      type: 'RollingUpdate',
    },
    template+: {
      spec+: {
        containers: [
          {
            env: [
              {
                name: 'GF_SECURITY_ADMIN_USER',
                valueFrom: {
                  secretKeyRef: {
                    key: 'admin-user',
                    name: 'glooe-grafana',
                  },
                },
              },
              {
                name: 'GF_SECURITY_ADMIN_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    key: 'admin-password',
                    name: 'glooe-grafana',
                  },
                },
              },
            ],
            image: 'grafana/grafana:6.4.2',
            imagePullPolicy: 'IfNotPresent',
            livenessProbe: {
              failureThreshold: 10,
              httpGet: {
                path: '/api/health',
                port: 3000,
              },
              initialDelaySeconds: 60,
              timeoutSeconds: 30,
            },
            name: 'grafana',
            ports: [
              {
                containerPort: 80,
                name: 'service',
                protocol: 'TCP',
              },
              {
                containerPort: 3000,
                name: 'grafana',
                protocol: 'TCP',
              },
            ],
            readinessProbe: {
              httpGet: {
                path: '/api/health',
                port: 3000,
              },
            },
            resources: {},
            volumeMounts: [
              {
                mountPath: '/etc/grafana/grafana.ini',
                name: 'config',
                subPath: 'grafana.ini',
              },
              {
                mountPath: '/var/lib/grafana',
                name: 'storage',
              },
              {
                mountPath: '/var/lib/grafana/dashboards/gloo',
                name: 'dashboards-gloo',
              },
              {
                mountPath: '/etc/grafana/provisioning/datasources/datasources.yaml',
                name: 'config',
                subPath: 'datasources.yaml',
              },
              {
                mountPath: '/etc/grafana/provisioning/dashboards/dashboardproviders.yaml',
                name: 'config',
                subPath: 'dashboardproviders.yaml',
              },
            ],
          },
        ],
        initContainers: [
          {
            command: [
              'chown',
              '-R',
              '472:472',
              '/var/lib/grafana',
            ],
            image: 'busybox:1.30',
            imagePullPolicy: 'IfNotPresent',
            name: 'init-chown-data',
            resources: {},
            securityContext: {
              runAsUser: 0,
            },
            volumeMounts: [
              {
                mountPath: '/var/lib/grafana',
                name: 'storage',
              },
            ],
          },
        ],
        securityContext: {
          fsGroup: 472,
          runAsUser: 472,
        },
        serviceAccountName: 'glooe-grafana',
        volumes: [
          {
            configMap: {
              name: 'glooe-grafana',
            },
            name: 'config',
          },
          {
            configMap: {
              name: 'glooe-grafana-custom-dashboards',
            },
            name: 'dashboards-gloo',
          },
          {
            name: 'storage',
            persistentVolumeClaim: {
              claimName: 'glooe-grafana',
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

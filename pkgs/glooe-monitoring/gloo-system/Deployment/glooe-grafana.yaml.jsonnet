local deployment(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    annotations: {
      'configmap.reloader.stakater.com/reload': 'glooe-grafana,glooe-grafana-custom-dashboards',
      'secret.reloader.stakater.com/reload': 'glooe-grafana',
    },
    labels: {
      app: 'glooe-grafana',
      chart: 'grafana-4.0.1',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-grafana',
    namespace: namespace,
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'glooe-grafana',
        release: 'glooe',
      },
    },
    strategy: {
      type: 'RollingUpdate',
    },
    template: {
      metadata: {
        annotations: {
          'checksum/config': '8e075c8327d7929162f2791f64196563f7f7f8846ce6b72aec6692ff546ab12e',
          'checksum/dashboards-json-config': '01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b',
          'checksum/sc-dashboard-provider-config': '01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b',
          'checksum/secret': '48c555f93471f6da4fd28c8c25aa6fa6fea6609e9b049357364ffc67df191660',
        },
        labels: {
          app: 'glooe-grafana',
          release: 'glooe',
        },
      },
      spec: {
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

function(config, prev, namespace) deployment(namespace)

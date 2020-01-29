local lib = import '../../../../lib/lib.jsonnet';

local deployment(config) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'glooe-prometheus',
      chart: 'prometheus-9.5.1',
      component: 'server',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-prometheus-server',
    namespace: 'gloo-system',
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'glooe-prometheus',
        component: 'server',
        release: 'glooe',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'glooe-prometheus',
          chart: 'prometheus-9.5.1',
          component: 'server',
          heritage: 'Helm',
          release: 'glooe',
        },
      },
      spec: {
        containers: [
          {
            args: [
              '--volume-dir=/etc/config',
              '--webhook-url=http://127.0.0.1:9090/-/reload',
            ],
            image: 'jimmidyson/configmap-reload:v0.2.2',
            imagePullPolicy: 'IfNotPresent',
            name: 'glooe-prometheus-server-configmap-reload',
            resources: {},
            volumeMounts: [
              {
                mountPath: '/etc/config',
                name: 'config-volume',
                readOnly: true,
              },
            ],
          },
          {
            args: [
              '--storage.tsdb.retention.time=%s' % lib.getElse(config, 'pkgs.glooe-prometheus-server.retention', '2d'),
              '--config.file=/etc/config/prometheus.yml',
              '--storage.tsdb.path=/data',
              '--web.console.libraries=/etc/prometheus/console_libraries',
              '--web.console.templates=/etc/prometheus/consoles',
              '--web.enable-lifecycle',
            ],
            image: 'prom/prometheus:v2.13.1',
            imagePullPolicy: 'IfNotPresent',
            livenessProbe: {
              httpGet: {
                path: '/-/healthy',
                port: 9090,
              },
              initialDelaySeconds: 180,
              timeoutSeconds: 30,
            },
            name: 'glooe-prometheus-server',
            ports: [
              {
                containerPort: 9090,
              },
            ],
            readinessProbe: {
              httpGet: {
                path: '/-/ready',
                port: 9090,
              },
              initialDelaySeconds: 180,
              timeoutSeconds: 30,
            },
            resources: {},
            volumeMounts: [
              {
                mountPath: '/etc/config',
                name: 'config-volume',
              },
              {
                mountPath: '/data',
                name: 'storage-volume',
                subPath: '',
              },
            ],
          },
        ],
        securityContext: {
          fsGroup: 65534,
          runAsGroup: 65534,
          runAsNonRoot: true,
          runAsUser: 65534,
        },
        serviceAccountName: 'glooe-prometheus-server',
        terminationGracePeriodSeconds: 300,
        volumes: [
          {
            configMap: {
              name: 'glooe-prometheus-server',
            },
            name: 'config-volume',
          },
          {
            name: 'storage-volume',
            persistentVolumeClaim: {
              claimName: 'glooe-prometheus-server',
            },
          },
        ],
      },
    },
  },
};

function(config, prev) deployment(config)


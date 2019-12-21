local lib = import '../../lib/lib.jsonnet';

local deployment(config) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'opencensus',
      component: 'oc-collector',
    },
    name: 'oc-collector',
    namespace: 'tracing',
  },
  spec: {
    minReadySeconds: 5,
    progressDeadlineSeconds: 120,
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'opencensus',
      },
    },
    template: {
      metadata: {
        annotations: {
          'linkerd.io/inject': if lib.getElse(config, 'pkgs.linkerd.enabled', false) then "enabled" else "disabled",
          'prometheus.io/path': '/metrics',
          'prometheus.io/port': '8888',
          'prometheus.io/scrape': 'true',
        },
        labels: {
          app: 'opencensus',
          component: 'oc-collector',
        },
      },
      spec: {
        containers: [
          {
            command: [
              '/occollector_linux',
              '--config=/conf/oc-collector-config.yaml',
            ],
            env: [
              {
                name: 'GOGC',
                value: '80',
              },
            ],
            image: 'omnition/opencensus-collector:0.1.10',
            livenessProbe: {
              httpGet: {
                path: '/',
                port: 13133,
              },
            },
            name: 'oc-collector',
            ports: [
              {
                containerPort: 55678,
              },
              {
                containerPort: 9411,
              },
            ],
            readinessProbe: {
              httpGet: {
                path: '/',
                port: 13133,
              },
            },
            resources: {
              limits: {
                cpu: 1,
                memory: '2Gi',
              },
              requests: {
                cpu: '200m',
                memory: '400Mi',
              },
            },
            volumeMounts: [
              {
                mountPath: '/conf',
                name: 'oc-collector-config-vol',
              },
            ],
          },
        ],
        volumes: [
          {
            configMap: {
              items: [
                {
                  key: 'oc-collector-config',
                  path: 'oc-collector-config.yaml',
                },
              ],
              name: 'oc-collector-conf',
            },
            name: 'oc-collector-config-vol',
          },
        ],
      },
    },
  },
};

function(config,prev) function deployment(config)

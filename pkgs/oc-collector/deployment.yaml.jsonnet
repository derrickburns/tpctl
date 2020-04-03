local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local global = import '../../lib/global.jsonnet';

local deployment(config, me) = k8s.deployment(me) {
  spec+: {
    minReadySeconds: 5,
    progressDeadlineSeconds: 120,
    template+: {
      metadata: {
        annotations:
          (if global.isEnabled(config, 'prometheus')
           then {
             'prometheus.io/path': '/metrics',
             'prometheus.io/port': '8888',
             'prometheus.io/scrape': 'true',
           }
           else {}) +
          (if global.isEnabled(config, 'linkerd')
           then {
             'linkerd.io/inject': 'enabled',
           }
           else {}),
      },
      spec+: {
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
            image: 'omnition/opencensus-collector:0.1.11',
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
              {
                name: 'metrics',
                containerPort: 8888,
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
              name: me.pkg,
            },
            name: 'oc-collector-config-vol',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(config, lib.package(config, namespace, pkg))

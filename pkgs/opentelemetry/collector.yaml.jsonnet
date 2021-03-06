local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

local configmap(me) = k8s.configmap(me, name='otel-collector-conf') {
  data: {
    'otel-collector-config': std.manifestYamlDoc(
      {
        receivers: {
          opencensus: null,
          otlp: {
            protocols: {
              grpc: null,
              http: null,
            },
          },
          jaeger: {
            protocols: {
              grpc: null,
              thrift_http: null,
            },
          },
        },
        processors: {
          batch: null,
          memory_limiter: {
            ballast_size_mib: 683,
            limit_mib: 1500,
            spike_limit_mib: 512,
            check_interval: '5s',
          },
          queued_retry: null,
        },
        extensions: {
          health_check: {},
          zpages: {},
        },
        exporters: {
          jaeger: {
            endpoint: 'jaeger-collector.observability:14250',
            insecure: true,
          },
          prometheus: {
            endpoint: ':8889',
            namespace: 'monitoring',
          },
        },
        service: {
          extensions: [
            'health_check',
            'zpages',
          ],
          pipelines: {
            metrics: {
              receivers: [
                'opencensus',
                'otlp',
              ],
              exporters: [
                'prometheus',
              ]
            },
            traces: {
              receivers: [
                'otlp',
                'jaeger',
                'opencensus',
              ],
              processors: [
                'memory_limiter',
                'batch',
                'queued_retry',
              ],
              exporters: [
                'jaeger',
              ],
            },
          },
        },
      }
    ),
  },
};

local deployment(me) = k8s.deployment(
  me,
  containers=[
    {
      command: [
        '/otelcol',
        '--config=/conf/otel-collector-config.yaml',
        '--mem-ballast-size-mib=683',
      ],
      image: 'otel/opentelemetry-collector-dev:latest',
      name: 'otel-collector',
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
      ports: [
        {
          containerPort: 55679,
        },
        {
          containerPort: 55680,
        },
        {
          containerPort: 14250,
        },
        {
          containerPort: 14268,
        },
        {
          containerPort: 9411,
        },
        {
          containerPort: 8888,
        },
      ],
      volumeMounts: [
        {
          name: 'otel-collector-config-vol',
          mountPath: '/conf',
        },
      ],
      livenessProbe: {
        httpGet: {
          path: '/',
          port: 13133,
        },
      },
      readinessProbe: {
        httpGet: {
          path: '/',
          port: 13133,
        },
      },
    },
  ],
  volumes=[
    {
      name: 'otel-collector-config-vol',
      configMap: {
        name: 'otel-collector-conf',
        items: [
          {
            key: 'otel-collector-config',
            path: 'otel-collector-config.yaml',
          },
        ],
      },
    },
  ],
) {
  metadata: {
    labels: {
      app: 'opentelemetry',
      component: 'otel-collector',
    },
    annotations: {
      'configmap.reloader.stakater.com/reload': 'otel-collector-conf',
    },
    namespace: me.namespace,
    name: 'otel-collector',
  },
  spec+: {
    selector: {
      matchLabels: {
        app: 'opentelemetry',
        component: 'otel-collector',
      },
    },
    template+: {
      metadata: {
        labels: {
          app: 'opentelemetry',
          component: 'otel-collector',
        },
        annotations: {
          'linkerd.io/inject': 'enabled',
        },
      },
    },
  },
};

local service(me) = k8s.service(me) {
  metadata: {
    name: 'otel-collector',
    namespace: me.namespace,
    labels: {
      app: 'opentelemetry',
      component: 'otel-collector',
    },
  },
  spec+: {
    ports: [
      k8s.port(55678, 55678, 'opencensus'),
      k8s.port(55680, 55680, 'otlp'),
      k8s.port(14250, 14250, 'jaeger-grpc'),
      k8s.port(14268, 14268, 'jaeger-thrift-http'),
      k8s.port(9411, 9411, 'zipkin'),
      k8s.port(8888, 8888, 'metrics'),
    ],
    selector: {
      component: 'otel-collector',
      app: 'opentelemetry',
    },
  },
};

local servicemonitor(me) = prom.Servicemonitor(me, 8888) {
  metadata: {
    name: 'otel-collector',
    namespace: me.namespace,
    labels: {
      app: 'opentelemetry',
      component: 'otel-collector',
    },
  },
  spec: {
    endpoints: [
      {
        honorLabels: true,
        port: 'metrics',
      },
    ],
    namespaceSelector: {
      matchNames: [
        me.namespace,
      ],
    },
    selector: {
      matchLabels: {
        component: 'otel-collector',
        app: 'opentelemetry',
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    servicemonitor(me),
    configmap(me),
  ]
)

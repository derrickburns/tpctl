local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

local configmap(me) = k8s.configmap(me, name='otel-agent-conf') {
  data: {
    'otel-agent-config': std.manifestYamlDoc(
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
          otlp: {
            endpoint: 'otel-collector.observability:55680',
            insecure: true,
          },
        },
        service: {
          extensions: [
            'health_check',
            'zpages',
          ],
          pipelines: {
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
                'otlp',
              ],
            },
          },
        },
      }
    ),
  },
};

local daemonset(me) = k8s.daemonset(
  me,
  containers=[
    {
      command: [
        '/otelcol',
        '--config=/conf/otel-agent-config.yaml',
        '--mem-ballast-size-mib=165',
      ],
      image: 'otel/opentelemetry-collector-dev:latest',
      name: 'otel-agent',
      resources: {
        limits: {
          cpu: '500m',
          memory: '500Mi',
        },
        requests: {
          cpu: '100m',
          memory: '100Mi',
        },
      },
      ports: [
        {
          containerPort: 55679,
          hostPort: 55679,
        },
        {
          containerPort: 55680,
          hostPort: 55680,
        },
        {
          containerPort: 14250,
          hostPort: 14250,
        },
        {
          containerPort: 14268,
          hostPort: 14268,
        },
        {
          containerPort: 9411,
          hostPort: 9411,
        },
        {
          containerPort: 8888,
          hostPort: 8888,
        },
      ],
      volumeMounts: [
        {
          name: 'otel-agent-config-vol',
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
      configMap: {
        name: 'otel-agent-conf',
        items: [
          {
            key: 'otel-agent-config',
            path: 'otel-agent-config.yaml',
          },
        ],
      },
      name: 'otel-agent-config-vol',
    },
  ],
) {
  metadata: {
    labels: {
      app: 'otel-agent',
    },
    name: 'otel-agent',
    namespace: me.namespace,
  },
  spec+: {
    selector: {
      matchLabels: {
        app: 'opentelemetry',
        component: 'otel-agent',
      },
    },
    template+: prom.metadata(me.config, 8888) + linkerd.metadata(me, true) {
      metadata: {
        labels: {
          app: 'opentelemetry',
          component: 'otel-agent',
        },
      },
    },
  },
};


local service(me) = k8s.service(me) {
  metadata: {
    name: 'otel-agent',
    namespace: me.namespace,
    labels: {
      app: 'opentelemetry',
      component: 'otel-agent',
    },
  },
  spec: {
    ports: [
      k8s.port(55678, 55678, 'opencensus'),
      k8s.port(55680, 55680, 'otlp'),
      k8s.port(14250, 14250, 'jaeger-grpc'),
      k8s.port(14268, 14268, 'jaeger-thrift-http'),
      k8s.port(9411, 9411, 'zipkin'),
      k8s.port(8888, 8888, 'metrics'),
    ],
    selector: {
      component: 'otel-agent',
      app: 'opentelemetry',
    },
  },
};

local servicemonitor(me) = prom.Servicemonitor(me, 8888) {
  metadata: {
    name: 'otel-agent',
    namespace: me.namespace,
    labels: {
      app: 'otel-agent',
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
        component: 'otel-agent',
        app: 'opentelemetry',
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    daemonset(me),
    servicemonitor(me),
    configmap(me),
  ]
)

local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

// This presumes that there is a jaeger collector running in the same namspace and it
// is called `jaeger-collector`

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
                'jaeger',
              ],
            },
          },
        },
      }
    ),
  },
};

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: prom.metadata(me.config, 8888) + linkerd.metadata(me, true) {
      spec+: {
        containers: [
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
        volumes: [
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
      },
    },
  },
};


local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      k8s.port(55678, 55678, 'opencensus'),
      k8s.port(55680, 55680, 'otlp'),
      k8s.port(14250, 14250, 'jaeger-grpc'),
      k8s.port(14268, 14268, 'jaeger-thrift-http'),
      k8s.port(9411, 9411, 'zipkin'),
      k8s.port(8888, 8888, 'metrics'),
    ],
  },
};

local servicemonitor(me) = prom.Servicemonitor(me, 8888);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    servicemonitor(me),
    configmap(me),
  ]
)

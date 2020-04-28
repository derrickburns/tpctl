local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

// This presumes that there is a jaeger collector running in the same namspace and it
// is called `jaeger-collector`

local configmap(me) = k8s.configmap(me) {
  data: {
    'oc-collector-config': std.manifestJsonEx(
      {
        'queued-exporters': {
          'jaeger-all-in-one': {
            'jaeger-thrift-http': {
              'collector-endpoint': 'http://jaeger-collector.%s:14268/api/traces' % me.namespace,  // XXX hardcoding
              timeout: '5s',
            },
            'num-workers': 4,
            'queue-size': 100,
            'retry-on-failure': true,
            'sender-type': 'jaeger-thrift-http',
          },
        },
        receivers: {
          opencensus: {
            port: 55678,
          },
        },
      }, '  '
    ),
  },
};

local deployment(me) = k8s.deployment(me) {
  spec+: {
    minReadySeconds: 5,
    progressDeadlineSeconds: 120,
    template+: prom.metadata(me.config, 8888) + linkerd.metadata(me, true) {
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
            name: me.pkg,
            ports: [
              {
                name: "opencensus",
                containerPort: 55678,
              },
              {
                name: 'zipkin',
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


local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      k8s.port(55678, 55678, 'opencensus'),
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

local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    ['%s-configmap-reload' % me.pkg]: {
      args: [
        '--volume-dir=/etc/config',
        '--webhook-url=http://127.0.0.1:9090/-/reload',
      ],
      image: 'jimmidyson/configmap-reload:v0.2.2',
      volumeMounts: [
        {
          mountPath: '/etc/config',
          name: 'config-volume',
          readOnly: true,
        },
      ],
    },
    [me.pkg]: {
      args: [
        '--storage.tsdb.retention.time=%s' % lib.getElse(me, 'retention', '2d'),
        '--config.file=/etc/config/prometheus.yml',
        '--storage.tsdb.path=/data',
        '--web.console.libraries=/etc/prometheus/console_libraries',
        '--web.console.templates=/etc/prometheus/consoles',
        '--web.enable-lifecycle',
      ],
      image: 'prom/prometheus:v2.13.1',
      livenessProbe: {
        httpGet: {
          path: '/-/healthy',
          port: 9090,
        },
        initialDelaySeconds: 180,
        timeoutSeconds: 30,
      },
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
  },
  spec+: {
    template+: {
      spec+: {
        securityContext: {
          fsGroup: 65534,
          runAsGroup: 65534,
          runAsNonRoot: true,
          runAsUser: 65534,
        },
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 300,
        volumes: [
          {
            configMap: {
              name: me.pkg,
            },
            name: 'config-volume',
          },
          {
            name: 'storage-volume',
            persistentVolumeClaim: {
              claimName: me.pkg,
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

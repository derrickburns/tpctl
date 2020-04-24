local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers: {
    _env:: {
      GF_SECURITY_ADMIN_USER: k8s._envSecret( me.pkg, 'admin-user'),
      GF_SECURITY_ADMIN_PASSWORD: k8s._envSecret( me.pkg, 'admin-password'),
    },
    image: 'grafana/grafana:6.4.2',
    livenessProbe: {
      failureThreshold: 10,
      httpGet: {
        path: '/api/health',
        port: 3000,
      },
      initialDelaySeconds: 60,
      timeoutSeconds: 30,
    },
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
  spec+: {
    template+: {
      spec+: {
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
        serviceAccountName: me.pkg,
        volumes: [
          {
            configMap: {
              name: me.pkg,
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
              claimName: me.pkg,
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    strategy+: {
      type: 'RollingUpdate',
    },
    template+: {
      spec+: {
        containers: [
          {
            env: [
              k8s.envSecret('GF_SECURITY_ADMIN_USER', me.pkg, 'admin-user'),
              k8s.envSecret('GF_SECURITY_ADMIN_PASSWORD', me.pkg, 'admin-password'),
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
            name: me.pkg,
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

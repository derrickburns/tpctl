local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local daemonset(config, me) = k8s.daemonset(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            env: [
              k8s.envVar('AWS_REGION', config.cluster.metadata.region),
              k8s.envVar('REGION', config.cluster.metadata.region),
              k8s.envVar('CLUSTER_NAME', config.cluster.metadata.name),
            ],
            image: 'fluent/fluentd-kubernetes-daemonset:v1.9.2-debian-cloudwatch-1.0',
            name: 'fluentd-cloudwatch',
            resources: {
              limits: {
                memory: '300Mi',
              },
              requests: {
                cpu: '100m',
                memory: '200Mi',
              },
            },
            volumeMounts: [
              {
                mountPath: '/config-volume',
                name: 'config-volume',
              },
              {
                mountPath: '/fluentd/etc',
                name: 'fluentdconf',
              },
              {
                mountPath: '/var/log',
                name: 'varlog',
              },
              {
                mountPath: '/var/lib/docker/containers',
                name: 'varlibdockercontainers',
                readOnly: true,
              },
              {
                mountPath: '/run/log/journal',
                name: 'runlogjournal',
                readOnly: true,
              },
              {
                mountPath: '/var/log/dmesg',
                name: 'dmesg',
                readOnly: true,
              },
            ],
          },
        ],
        initContainers: [
          {
            command: [
              'sh',
              '-c',
              'cp /config-volume/..data/* /fluentd/etc',
            ],
            image: 'busybox:1.31.1',
            name: 'copy-fluentd-config',
            volumeMounts: [
              {
                mountPath: '/config-volume',
                name: 'config-volume',
              },
              {
                mountPath: '/fluentd/etc',
                name: 'fluentdconf',
              },
            ],
          },
          {
            command: [
              'sh',
              '-c',
              '',
            ],
            image: 'busybox:1.31.1',
            name: 'update-log-driver',
          },
        ],
        securityContext: {
          fsGroup: 65534,
        },
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 30,
        volumes: [
          {
            configMap: {
              name: 'fluentd-config',
            },
            name: 'config-volume',
          },
          {
            emptyDir: {},
            name: 'fluentdconf',
          },
          {
            hostPath: {
              path: '/var/log',
            },
            name: 'varlog',
          },
          {
            hostPath: {
              path: '/var/lib/docker/containers',
            },
            name: 'varlibdockercontainers',
          },
          {
            hostPath: {
              path: '/run/log/journal',
            },
            name: 'runlogjournal',
          },
          {
            hostPath: {
              path: '/var/log/dmesg',
            },
            name: 'dmesg',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) daemonset(config, common.package(config, prev, namespace, pkg))

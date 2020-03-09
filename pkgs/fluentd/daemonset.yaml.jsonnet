local lib = import '../../lib/lib.jsonnet';

local daemonset(config, namespace) = {
  apiVersion: 'apps/v1',
  kind: 'DaemonSet',
  metadata: {
    labels: {
      'k8s-app': 'fluentd-cloudwatch',
    },
    name: 'fluentd-cloudwatch',
    namespace: namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        'k8s-app': 'fluentd-cloudwatch',
      },
    },
    template: {
      metadata: {
        annotations: {
          configHash: '8915de4cf9c3551a8dc74c0137a3e83569d28c71044b0359c2578d2e0461825',
        },
        labels: {
          'k8s-app': 'fluentd-cloudwatch',
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'AWS_REGION',
                value: config.cluster.metadata.region,
              },
              {
                name: 'REGION',
                valueFrom: {
                  configMapKeyRef: {
                    key: 'logs.region',
                    name: 'cluster-info',
                  },
                },
              },
              {
                name: 'CLUSTER_NAME',
                valueFrom: {
                  configMapKeyRef: {
                    key: 'cluster.name',
                    name: 'cluster-info',
                  },
                },
              },
            ],
            image: 'fluent/fluentd-kubernetes-daemonset:v1.8.1-debian-cloudwatch-1.1',
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
        serviceAccountName: 'fluentd',
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

function(config, prev, namespace) daemonset(config, namespace)

local lib = import '../../lib/lib.jsonnet';

local daemonset(config, me) = {
  apiVersion: 'apps/v1',
  kind: 'DaemonSet',
  metadata: {
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        name: me.pkg,
      },
    },
    template: {
      metadata: {
        labels: {
          name: me.pkg,
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'CLUSTER_NAME',
                value: config.cluster.metadata.name,
              },
              {
                name: 'HOST_IP',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'status.hostIP',
                  },
                },
              },
              {
                name: 'HOST_NAME',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'spec.nodeName',
                  },
                },
              },
              {
                name: 'K8S_NAMESPACE',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'metadata.namespace',
                  },
                },
              },
            ],
            image: 'amazon/cloudwatch-agent:latest',
            imagePullPolicy: 'Always',
            name: me.pkg,
            resources: {
              limits: {
                cpu: '200m',
                memory: '200Mi',
              },
              requests: {
                cpu: '200m',
                memory: '200Mi',
              },
            },
            volumeMounts: [
              {
                mountPath: '/etc/cwagentconfig',
                name: 'cwagentconfig',
              },
              {
                mountPath: '/rootfs',
                name: 'rootfs',
                readOnly: true,
              },
              {
                mountPath: '/var/run/docker.sock',
                name: 'dockersock',
                readOnly: true,
              },
              {
                mountPath: '/var/lib/docker',
                name: 'varlibdocker',
                readOnly: true,
              },
              {
                mountPath: '/sys',
                name: 'sys',
                readOnly: true,
              },
              {
                mountPath: '/dev/disk',
                name: 'devdisk',
                readOnly: true,
              },
            ],
          },
        ],
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 60,
        volumes: [
          {
            configMap: {
              name: 'cwagentconfig',
            },
            name: 'cwagentconfig',
          },
          {
            hostPath: {
              path: '/',
            },
            name: 'rootfs',
          },
          {
            hostPath: {
              path: '/var/run/docker.sock',
            },
            name: 'dockersock',
          },
          {
            hostPath: {
              path: '/var/lib/docker',
            },
            name: 'varlibdocker',
          },
          {
            hostPath: {
              path: '/sys',
            },
            name: 'sys',
          },
          {
            hostPath: {
              path: '/dev/disk/',
            },
            name: 'devdisk',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) daemonset(config, lib.package(config, namespace, pkg))

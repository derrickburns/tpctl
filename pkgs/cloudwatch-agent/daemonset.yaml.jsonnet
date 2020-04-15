local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local daemonset(config, me) = k8s.daemonset(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            env: [
              k8s.envVar('CLUSTER_NAME', config.cluster.metadata.name),
              k8s.envField('HOST_IP', 'status.hostIP'),
              k8s.envField('HOST_NAME', 'spec.nodeName'),
              k8s.envField('K8S_NAMESPACE', 'metadata.namespace'),
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

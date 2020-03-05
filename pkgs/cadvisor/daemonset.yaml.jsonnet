local daemonset(config, namespace) = {
  apiVersion: 'apps/v1',
  kind: 'DaemonSet',
  metadata: {
    annotations: {
      'seccomp.security.alpha.kubernetes.io/pod': 'docker/default',
    },
    name: 'cadvisor',
    namespace: namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        name: 'cadvisor',
      },
    },
    template: {
      metadata: {
        labels: {
          name: 'cadvisor',
        },
      },
      spec: {
        automountServiceAccountToken: false,
        containers: [
          {
            args: [
              '--v=4',
            ],
            image: 'k8s.gcr.io/cadvisor:v0.34.0',
            name: 'cadvisor',
            ports: [
              {
                containerPort: 8080,
                name: 'http',
                protocol: 'TCP',
              },
            ],
            resources: {
              limits: {
                cpu: '300m',
                memory: '2000Mi',
              },
              requests: {
                cpu: '150m',
                memory: '200Mi',
              },
            },
            securityContext: {
              privileged: true,
            },
            volumeMounts: [
              {
                mountPath: '/rootfs',
                name: 'rootfs',
                readOnly: true,
              },
              {
                mountPath: '/var/run',
                name: 'var-run',
                readOnly: true,
              },
              {
                mountPath: '/sys',
                name: 'sys',
                readOnly: true,
              },
              {
                mountPath: '/var/lib/docker',
                name: 'docker',
                readOnly: true,
              },
              {
                mountPath: '/dev/disk',
                name: 'disk',
                readOnly: true,
              },
            ],
          },
        ],
        serviceAccountName: 'cadvisor',
        terminationGracePeriodSeconds: 30,
        volumes: [
          {
            hostPath: {
              path: '/',
            },
            name: 'rootfs',
          },
          {
            hostPath: {
              path: '/var/run',
            },
            name: 'var-run',
          },
          {
            hostPath: {
              path: '/sys',
            },
            name: 'sys',
          },
          {
            hostPath: {
              path: '/var/lib/docker',
            },
            name: 'docker',
          },
          {
            hostPath: {
              path: '/dev/disk',
            },
            name: 'disk',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace) daemonset(config, namespace)

local deployment(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard',
    namespace: namespace,
  },
  spec: {
    replicas: 1,
    revisionHistoryLimit: 10,
    selector: {
      matchLabels: {
        'k8s-app': 'kubernetes-dashboard',
      },
    },
    template: {
      metadata: {
        labels: {
          'k8s-app': 'kubernetes-dashboard',
        },
      },
      spec: {
        containers: [
          {
            args: [
              '--auto-generate-certificates',
              '--namespace=kubernetes-dashboard',
            ],
            image: 'kubernetesui/dashboard:v2.0.0-beta8',
            imagePullPolicy: 'Always',
            livenessProbe: {
              httpGet: {
                path: '/',
                port: 8443,
                scheme: 'HTTPS',
              },
              initialDelaySeconds: 30,
              timeoutSeconds: 30,
            },
            name: 'kubernetes-dashboard',
            ports: [
              {
                containerPort: 8443,
                protocol: 'TCP',
              },
            ],
            securityContext: {
              allowPrivilegeEscalation: false,
              readOnlyRootFilesystem: true,
              runAsGroup: 2001,
              runAsUser: 1001,
            },
            volumeMounts: [
              {
                mountPath: '/certs',
                name: 'kubernetes-dashboard-certs',
              },
              {
                mountPath: '/tmp',
                name: 'tmp-volume',
              },
            ],
          },
        ],
        nodeSelector: {
          'beta.kubernetes.io/os': 'linux',
        },
        serviceAccountName: 'kubernetes-dashboard',
        tolerations: [
          {
            effect: 'NoSchedule',
            key: 'node-role.kubernetes.io/master',
          },
        ],
        volumes: [
          {
            name: 'kubernetes-dashboard-certs',
            secret: {
              secretName: 'kubernetes-dashboard-certs',
            },
          },
          {
            emptyDir: {},
            name: 'tmp-volume',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace) deployment(namespace)
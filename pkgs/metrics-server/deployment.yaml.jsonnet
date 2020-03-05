local deployment(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      'k8s-app': 'metrics-server',
    },
    name: 'metrics-server',
    namespace: namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        'k8s-app': 'metrics-server',
      },
    },
    template: {
      metadata: {
        labels: {
          'k8s-app': 'metrics-server',
        },
        name: 'metrics-server',
      },
      spec: {
        containers: [
          {
            command: [
              '/metrics-server',
              '--v=2',
              '--metric-resolution=30s',
              '--kubelet-insecure-tls',
              '--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP',
            ],
            image: 'k8s.gcr.io/metrics-server-amd64:v0.3.6',
            imagePullPolicy: 'Always',
            name: 'metrics-server',
            volumeMounts: [
              {
                mountPath: '/tmp',
                name: 'tmp-dir',
              },
            ],
          },
        ],
        serviceAccountName: 'metrics-server',
        volumes: [
          {
            emptyDir: {},
            name: 'tmp-dir',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace) deployment(namespace)

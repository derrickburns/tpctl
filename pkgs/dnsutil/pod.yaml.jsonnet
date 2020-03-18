local pod(namespace) = {
  apiVersion: 'v1',
  kind: 'Pod',
  metadata: {
    name: 'dnsutils',
    namespace: namespace,
  },
  spec: {
    containers: [
      {
        command: [
          'sleep',
          '3600',
        ],
        image: 'gcr.io/kubernetes-e2e-test-images/dnsutils:1.3',
        imagePullPolicy: 'IfNotPresent',
        name: 'dnsutils',
      },
    ],
    restartPolicy: 'Always',
  },
};

function(config, prev, namespace, pkg) pod(namespace)

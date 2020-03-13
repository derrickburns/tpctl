local apiservice(namespace) = {
  apiVersion: 'apiregistration.k8s.io/v1beta1',
  kind: 'APIService',
  metadata: {
    name: 'v1beta1.metrics.k8s.io',
  },
  spec: {
    group: 'metrics.k8s.io',
    groupPriorityMinimum: 100,
    insecureSkipTLSVerify: true,
    service: {
      name: 'metrics-server',
      namespace: namespace,
    },
    version: 'v1beta1',
    versionPriority: 100,
  },
};

function(config, prev, namespace) apiservice(namespace)

local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'true',
    },
    name: 'sumologic-fluentd',
    namespace: 'sumologic',
  },
  spec: {
    chart: {
      name: 'sumologic-fluentd',
      repository: 'https://sumologic.github.io/sumologic-kubernetes-collection',
      version: '0.13.0',
    },
    releaseName: 'collection',

    'prometheus-operator': {
      prometheus: {
        prometheusSpec: {
          externalLabels: {
            cluster: config.cluster.metadata.name,
          },
        },
      },
      enabled: false,
    },

    clusterName: config.cluster.metadata.name,

    image: {
      pullPolicy: 'IfNotPresent',
      repository: 'sumologic/kubernetes-fluentd',
      tag: '0.13.0',
    },
    sumologic: {
      envFromSecret: 'sumologic',
      excludeNamespaceRegex: 'amazon-cloudwatch|external-dns|external-secrets|flux|kube-.*|linkerd|monitoring|reloader|sumologic',
      readFromHead: false,
      sourceCategoryPrefix: 'kubernetes/%s/' % config.cluster.metadata.name,

    },
  },
};

function(config, prev) helmrelease(config)

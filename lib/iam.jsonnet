{
  metadata(serviceAccountName, namespace):: {
    metadata: {
      labels: {
        'aws-usage': serviceAccountName + '-service',
      },
      name: serviceAccountName,
      namespace: namespace,
    },
  },
}

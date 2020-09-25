{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'authconfigs.enterprise.gloo.solo.io',
  },
  spec: {
    group: 'enterprise.gloo.solo.io',
    names: {
      kind: 'AuthConfig',
      listKind: 'AuthConfigList',
      plural: 'authconfigs',
      shortNames: [
        'ac',
      ],
      singular: 'authconfig',
    },
    scope: 'Namespaced',
    version: 'v1',
    versions: [
      {
        name: 'v1',
        served: true,
        storage: true,
      },
    ],
  },
}

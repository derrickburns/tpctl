{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    labels: {
      gloo: 'settings',
    },
    name: 'settings.gloo.solo.io',
  },
  spec: {
    group: 'gloo.solo.io',
    names: {
      kind: 'Settings',
      listKind: 'SettingsList',
      plural: 'settings',
      shortNames: [
        'st',
      ],
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

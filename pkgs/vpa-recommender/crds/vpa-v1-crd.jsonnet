{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'api-approved.kubernetes.io': 'https://github.com/kubernetes/kubernetes/pull/63797',
    },
    name: 'verticalpodautoscalers.autoscaling.k8s.io',
  },
  spec: {
    group: 'autoscaling.k8s.io',
    names: {
      kind: 'VerticalPodAutoscaler',
      plural: 'verticalpodautoscalers',
      shortNames: [
        'vpa',
      ],
      singular: 'verticalpodautoscaler',
    },
    scope: 'Namespaced',
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            properties: {
              resourcePolicy: {
                properties: {
                  containerPolicies: {
                    items: {
                      properties: {
                        containerName: {
                          type: 'string',
                        },
                        controlledResources: {
                          items: {
                            enum: [
                              'cpu',
                              'memory',
                            ],
                            type: 'string',
                          },
                          type: 'array',
                        },
                        maxAllowed: {
                          type: 'object',
                        },
                        minAllowed: {
                          type: 'object',
                        },
                        mode: {
                          enum: [
                            'Auto',
                            'Off',
                          ],
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              targetRef: {
                type: 'object',
              },
              updatePolicy: {
                properties: {
                  updateMode: {
                    type: 'string',
                  },
                },
                type: 'object',
              },
            },
            required: [],
            type: 'object',
          },
        },
        type: 'object',
      },
    },
    version: 'v1beta1',
    versions: [
      {
        name: 'v1beta1',
        served: false,
        storage: false,
      },
      {
        name: 'v1beta2',
        served: true,
        storage: true,
      },
      {
        name: 'v1',
        served: true,
        storage: false,
      },
    ],
  },
}

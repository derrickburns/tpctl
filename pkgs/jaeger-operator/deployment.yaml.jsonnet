local deployment(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'jaeger-operator',
    namespace: namespace,
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        name: 'jaeger-operator',
      },
    },
    template: {
      metadata: {
        labels: {
          name: 'jaeger-operator',
        },
      },
      spec: {
        containers: [
          {
            args: [
              'start',
            ],
            env: [
              {
                name: 'WATCH_NAMESPACE',
                value: '',
              },
              {
                name: 'POD_NAME',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'metadata.name',
                  },
                },
              },
              {
                name: 'POD_NAMESPACE',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'metadata.namespace',
                  },
                },
              },
              {
                name: 'OPERATOR_NAME',
                value: 'jaeger-operator',
              },
            ],
            image: 'jaegertracing/jaeger-operator:1.17.0',
            imagePullPolicy: 'Always',
            name: 'jaeger-operator',
            ports: [
              {
                containerPort: 8383,
                name: 'metrics',
              },
            ],
          },
        ],
        serviceAccountName: 'jaeger-operator',
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(namespace)

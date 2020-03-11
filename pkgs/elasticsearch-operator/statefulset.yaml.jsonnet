local statefulset(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'StatefulSet',
  metadata: {
    labels: {
      'control-plane': 'elastic-operator',
    },
    name: 'elastic-operator',
    namespace: namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        'control-plane': 'elastic-operator',
      },
    },
    serviceName: 'elastic-operator',
    template: {
      metadata: {
        labels: {
          'control-plane': 'elastic-operator',
        },
      },
      spec: {
        containers: [
          {
            args: [
              'manager',
              '--operator-roles',
              'all',
              '--enable-debug-logs=false',
            ],
            env: [
              {
                name: 'OPERATOR_NAMESPACE',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'metadata.namespace',
                  },
                },
              },
              {
                name: 'WEBHOOK_SECRET',
                value: 'webhook-server-secret',
              },
              {
                name: 'WEBHOOK_PODS_LABEL',
                value: 'elastic-operator',
              },
              {
                name: 'OPERATOR_IMAGE',
                value: 'docker.elastic.co/eck/eck-operator:1.0.1',
              },
            ],
            image: 'docker.elastic.co/eck/eck-operator:1.0.1',
            name: 'manager',
            ports: [
              {
                containerPort: 9876,
                name: 'webhook-server',
                protocol: 'TCP',
              },
            ],
            resources: {
              limits: {
                cpu: 1,
                memory: '150Mi',
              },
              requests: {
                cpu: '100m',
                memory: '50Mi',
              },
            },
          },
        ],
        serviceAccountName: 'elastic-operator',
        terminationGracePeriodSeconds: 10,
      },
    },
  },
};

function(config, prev, namespace) statefulset(namespace)

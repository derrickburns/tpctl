local deployment(namespace) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    annotations: {
      'configmap.reloader.stakater.com/reload': 'glooe-observability-config',
      'secret.reloader.stakater.com/reload': 'license,glooe-observability-secrets',
    },
    labels: {
      app: 'gloo',
      gloo: 'observability',
    },
    name: 'observability',
    namespace: namespace,
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        app: 'gloo',
        gloo: 'observability',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'gloo',
          gloo: 'observability',
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'GLOO_LICENSE_KEY',
                valueFrom: {
                  secretKeyRef: {
                    key: 'license-key',
                    name: 'license',
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
            ],
            envFrom: [
              {
                configMapRef: {
                  name: 'glooe-observability-config',
                },
              },
              {
                secretRef: {
                  name: 'glooe-observability-secrets',
                },
              },
            ],
            image: 'quay.io/solo-io/observability-ee:1.2.2',
            imagePullPolicy: 'IfNotPresent',
            name: 'observability',
            volumeMounts: [
              {
                mountPath: '/observability',
                name: 'upstream-dashboard-template',
                readOnly: true,
              },
            ],
          },
        ],
        serviceAccountName: 'observability',
        volumes: [
          {
            configMap: {
              items: [
                {
                  key: 'DASHBOARD_JSON_TEMPLATE',
                  path: 'dashboard-template.json',
                },
              ],
              name: 'glooe-observability-config',
            },
            name: 'upstream-dashboard-template',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace) deployment(namespace)

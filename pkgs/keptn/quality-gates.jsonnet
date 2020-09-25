{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'lighthouse-service',
    namespace: 'keptn',
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        run: 'lighthouse-service',
      },
    },
    template: {
      metadata: {
        labels: {
          run: 'lighthouse-service',
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'EVENTBROKER',
                value: 'http://event-broker.keptn.svc.cluster.local/keptn',
              },
              {
                name: 'CONFIGURATION_SERVICE',
                value: 'http://configuration-service.keptn.svc.cluster.local:8080',
              },
              {
                name: 'MONGODB_DATASTORE',
                value: 'mongodb-datastore.keptn-datastore.svc.cluster.local:8080',
              },
              {
                name: 'ENVIRONMENT',
                value: 'production',
              },
            ],
            image: 'keptn/lighthouse-service:0.6.2',
            name: 'lighthouse-service',
            ports: [
              {
                containerPort: 8080,
              },
            ],
            resources: {
              limits: {
                cpu: '500m',
                memory: '1024Mi',
              },
              requests: {
                cpu: '50m',
                memory: '128Mi',
              },
            },
          },
        ],
      },
    },
  },
}

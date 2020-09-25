{
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'helm-service-service-create-distributor',
    namespace: 'keptn',
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        run: 'distributor',
      },
    },
    template: {
      metadata: {
        labels: {
          run: 'distributor',
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'PUBSUB_URL',
                value: 'nats://keptn-nats-cluster',
              },
              {
                name: 'PUBSUB_TOPIC',
                value: 'sh.keptn.internal.event.service.create',
              },
              {
                name: 'PUBSUB_RECIPIENT',
                value: 'helm-service',
              },
            ],
            image: 'keptn/distributor:0.6.2',
            name: 'distributor',
            ports: [
              {
                containerPort: 8080,
              },
            ],
            resources: {
              limits: {
                cpu: '500m',
                memory: '128Mi',
              },
              requests: {
                cpu: '50m',
                memory: '32Mi',
              },
            },
          },
        ],
      },
    },
  },
}

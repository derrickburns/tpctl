local lib = import '../../lib/lib.jsonnet';

local deployment(me) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        name: me.pkg,
      },
    },
    template: {
      metadata: {
        labels: {
          name: me.pkg,
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
                value: me.pkg,
              },
            ],
            image: 'jaegertracing/jaeger-operator:1.17.0',
            imagePullPolicy: 'Always',
            name: me.pkg,
            ports: [
              {
                containerPort: 8383,
                name: 'metrics',
              },
            ],
          },
        ],
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

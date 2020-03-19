local lib = import '../../lib/lib.jsonnet';

local statefulset(me) = {
  apiVersion: 'apps/v1',
  kind: 'StatefulSet',
  metadata: {
    labels: {
      'control-plane': me.pkg,
    },
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
    selector: {
      matchLabels: {
        'control-plane': me.pkg,
      },
    },
    serviceName: me.pkg,
    template: {
      metadata: {
        labels: {
          'control-plane': me.pkg,
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
                value: me.pkg,
              },
              {
                name: 'OPERATOR_IMAGE',
                value: 'docker.elastic.co/eck/eck-operator:1.0.0-beta1',
              },
            ],
            image: 'docker.elastic.co/eck/eck-operator:1.0.0-beta1',
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
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 10,
      },
    },
  },
};

function(config, prev, namespace, pkg) statefulset(lib.package(config, namespace, pkg))

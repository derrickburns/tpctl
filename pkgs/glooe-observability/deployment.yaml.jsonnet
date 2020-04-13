local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
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
                  name: me.pkg,
                },
              },
              {
                secretRef: {
                  name: me.pkg,
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
        serviceAccountName: me.pkg,
        volumes: [
          {
            configMap: {
              items: [
                {
                  key: 'DASHBOARD_JSON_TEMPLATE',
                  path: 'dashboard-template.json',
                },
              ],
              name: me.pkg,
            },
            name: 'upstream-dashboard-template',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config,namespace,pkg))

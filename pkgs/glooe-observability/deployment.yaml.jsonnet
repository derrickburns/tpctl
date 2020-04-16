local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            env: [
              k8s.envSecret('GLOO_LICENSE_KEY', 'license', 'license-key'),
              k8s.envField( 'POD_NAMESPACE', 'metadata.namespace'),
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
            name: me.pkg,
            volumeMounts: [
              {
                mountPath: '/observability',
                name: me.pkg,
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
            name: me.pkg,
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))

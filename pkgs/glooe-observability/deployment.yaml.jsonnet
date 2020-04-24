local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers: {
    _env:: {
      GLOO_LICENSE_KEY: k8s._envSecret( 'license', 'license-key'),
      POD_NAMESPACE: k8s._envField( 'metadata.namespace' ),
    },
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
    volumeMounts: [
      {
        mountPath: '/observability',
        name: me.pkg,
        readOnly: true,
      },
    ],
  },
  spec+: {
    template+: {
      spec+: {
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

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

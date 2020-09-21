local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(
  me,
  containers={
    env: [
      k8s.envSecret('GLOO_LICENSE_KEY', 'license', 'license-key'),
      k8s.envField('POD_NAMESPACE', 'metadata.namespace'),
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
    volumeMounts: [
      {
        mountPath: '/observability',
        name: me.pkg,
        readOnly: true,
      },
    ],
  },
  volumes=[
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
  serviceAccount=true
);

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

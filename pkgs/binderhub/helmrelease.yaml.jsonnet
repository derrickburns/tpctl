local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.2.0-n219.hbc17443', repository: 'https://jupyterhub.github.io/helm-chart' }) {
  spec+: {
    values: {
      config: {
        BinderHub: {
          use_registry: true,
          image_prefix: 'tidepool-org/binder-',
          hub_url: 'https://jupyterhub.%s' % me.config.cluster.metadata.domain,
        },
      },
      ingress: {
        enabled: false,
      },
      jupyterhub: {
        hub: {
          services: {
            binder: {
              apiToken: '0e8d3443518ddb4213c0fdab0fbc92983c08167507543940744b55b286fa299c',
            },
          },
        },
        proxy: {
          secretToken: '135ee9bdc45911d792536e6b5889b99dd395b6f18bcddf401060898505e07123',
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)

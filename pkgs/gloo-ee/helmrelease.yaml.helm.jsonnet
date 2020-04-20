local gloo = import '../../lib/gloo.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  local glooVersion = lib.getElse(me, 'gloo.version', '1.3.0');
  k8s.helmrelease(me, { name: 'gloo-ee', version: '1.3.0', repository: 'http://storage.googleapis.com/gloo-ee-helm' }) {
    spec+: {
      values: gloo.globalValues(me.config, me, glooVersion) + {
        gloo: gloo.glooValues(me.config, me, glooVersion),
        create_license_secret: false,
        global: {
          extensions: {
            extAuth: {
              existingSecret: 'ext-auth-signing-key',
            },
          },
        },
        persistence: {
          storageClassName: 'gp2-expanding',
        },
        devPortal: {
          enabled: true
        },
        prometheus: {
          server: {
            resources: {
              limits: {
                memory: '3Gi',
              },
              requests: {
                memory: '2Gi',
              },
            },
          },
        },
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

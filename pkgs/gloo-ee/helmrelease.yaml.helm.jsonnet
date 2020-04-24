local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  local config = me.config;
  local glooVersion = lib.getElse(me, 'gloo.version', '1.3.3');
  k8s.helmrelease(me, { name: 'gloo-ee', version: '1.3.3', repository: 'http://storage.googleapis.com/gloo-ee-helm' }) {
    spec+: {
      values: gloo.globalValues(config, me, glooVersion) + {
        gloo: gloo.glooValues(config, me, glooVersion),
        create_license_secret: false,
        global: {
          extensions: {
            extAuth: {
              existingSecret: 'ext-auth-signing-key',
            },
          },
        },
        devPortal: {
          enabled: true,
        },
        grafana: {
          persistence: {
            size: '1Gi',
            storageClassName: 'gp2-expanding',
          },
        },
        prometheus: {
          server: {
            persistentVolume: {
              storageClass: 'gp2-expanding',
              size: '30Gi',
            },
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

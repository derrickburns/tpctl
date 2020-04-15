local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = (
  local glooVersion = lib.getElse(me, 'gloo.version', '1.3.0');
  k8s.helmrelease(me, { name: 'gloo-ee', version: '1.3.0', repository: 'http://storage.googleapis.com/gloo-ee-helm' }) {
    spec+: {
      values: gloo.globalValues(config, me, glooVersion) + {
        gloo: gloo.glooValues(config, me, glooVersion),
        create_license_secret: false,
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

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))

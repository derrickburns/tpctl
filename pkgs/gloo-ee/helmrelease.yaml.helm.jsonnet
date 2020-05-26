local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  local config = me.config;
  k8s.helmrelease(me, { name: 'gloo-ee', version: '1.3.5', repository: 'http://storage.googleapis.com/gloo-ee-helm' }) {
    spec+: {
.Values.apiServer.deployment.server.resources
      values: gloo.globalValues(me) + {
        gloo: gloo.glooValues(me),
        create_license_secret: false,
        global+: {
          extensions+: {
            extAuth+: {
              existingSecret: 'ext-auth-signing-key',
            },
          },
        },
        apiServer: {
          deployment: {
            server: {
              resources: {
                limits: {
                  memory: '200Mi',
                },
                requests: {
                  memory: '100Mi',
                }, 
              },
            },
          },
        },
        devPortal: {
          enabled: true,
        },
        grafana: {
          defaultInstallationEnabled: lib.isEnabledAt(me, 'grafana'),
          persistence: {
            size: '1Gi',
            storageClassName: 'gp2-expanding',
          },
        },
        prometheus: {
          enabled: lib.isEnabledAt(me, 'prometheus'),
          server: {
            persistentVolume: {
              storageClass: 'gp2-expanding',
              size: lib.getElse(me, 'storage', '30Gi'),
            },
            resources: {
              limits: {
                memory: '4Gi',
              },
              requests: {
                memory: '3Gi',
              },
            },
          },
        },
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

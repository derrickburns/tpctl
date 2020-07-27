local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me, { version:'0.4.0', repository: 'https://k8s.ory.sh/helm/charts' }) {
    spec+: {
      values+: {
        ingress: {
          public: {
            enabled: false,
            },
          },
        },
        hydra: {
          dangerousForceHttp: true,
          config: {
            dsn: 'memory',
            urls: {
              'self': {
                issuer: 'https://hydra.%s/' % me.config.cluster.metadata.domain,
              },
              login: 'https://hydra-idp.%s/login' % me.config.cluster.metadata.domain,
              consent: 'https://hydra-idp.%s/consent' % me.config.cluster.metadata.domain,
              logout: 'https://hydra-idp.%s/logout' % me.config.cluster.metadata.domain,
            }
          }
        }
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

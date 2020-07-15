local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = (
  k8s.helmrelease(me, { version:'0.4.0', repository: 'https://k8s.ory.sh/helm/charts' }) {
    spec+: {
      values+: {
        hydra: {
          config: {
            dsn: 'memory',
            urls: {
              'self': {
                issuer: 'https://hydra.dev.tidepool.org/',
              },
              login: 'https://auth.dev.tidepool.org/login',
              consent: 'https://auth.dev.tidepool.org/consent',
              logout: 'https://auth.dev.tidepool.org/lgout'
            }
          }
        }
      },
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

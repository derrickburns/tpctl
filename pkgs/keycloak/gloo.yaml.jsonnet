local certmanager = import '../../lib/certmanager.jsonnet';
local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local pomerium = import '../../lib/pomerium.jsonnet';


local upstream(me) = gloo.kubeupstream(me, 80, 'keycloak-http') + {
  loadBalancerConfig: {
    ringHash: {
      ringHashConfig: {
        maximumRingSize: '200',
        minimumRingSize: '10'
      }
    }
  }
};

local virtualService(me) = gloo.virtualService(me) {
  spec+: {
    virtualHost: {
      domains: pomerium.dnsNameForSso(me.config, me, lib.require(me, 'sso')),
      routes: [
        {
          matchers: [
            {
              prefix: '/'
            },
          ],
          routeAction: {
            single: {
              upstream: {
                name: me.pkg,
                namespace: me.namespace,
              }
            }
          },
          options: {
            lbHash: {
              hashPolicies: [
                {
                  cookie: {
                    name: 'affinity',
                  },
                },
                {
                  sourceIp: true,
                }
              ],
            },
          }
        },
      ],
    },
  },
};


function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    upstream(me),
    virtualService(me),
  ]
)

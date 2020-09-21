local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local ClusterIssuer(me) = {
  local config = me.config,
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'ClusterIssuer',
  metadata: {
    name: 'letsencrypt-staging',
  },
  spec: {
    acme: {
      email: config.general.email,
      privateKeySecretRef: {
        name: 'letsencrypt-staging',
      },
      server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
      solvers: [
        {
          dns01: {
            route53: {  // XXX AWS dependency
              region: config.cluster.metadata.region,
            },
          },
          selector: {
            dnsZones: [
              config.cluster.metadata.rootDomain,
              '*.%s' % config.cluster.metadata.rootDomain,
            ],
          },
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) ClusterIssuer(common.package(config, prev, namespace, pkg))

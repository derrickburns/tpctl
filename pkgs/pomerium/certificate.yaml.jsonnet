local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';
local mylib = import 'lib.jsonnet';

local dnsNames(config, namespace) = (
  local domain = mylib.rootDomain(config);
  [
    'authenticate.%s' % domain,
    'authorize.%s' % domain,
  ]
  + mylib.dnsNames(config)
);

local certificate(config, namespace) = (
  local names = dnsNames(config, namespace);
  {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'Certificate',
    metadata: {
      name: 'pomerium-certificate',
      namespace: namespace,
    },
    spec: {
      secretName: 'pomerium-tls',
      issuerRef: {
        name: lib.getElse(global.package(config, 'certmanager'), 'issuer', 'letsencrypt-production'),
        kind: 'ClusterIssuer',
      },
      commonName: names[0],
      dnsNames: names,
    },
  }
);

function(config, prev, namespace, pkg) certificate(config, namespace)

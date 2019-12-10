local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local dnsNames(config) = (
  local domain = mylib.rootDomain(config);
  mylib.dnsNames(config) +
  [
    'authenticate.%s' % domain,
    'authorize.%s' % domain,
  ]
);

local certificate(config) = (
  local names = dnsNames(config);
  {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'Certificate',
    metadata: {
      name: 'pomerium-certificate',
      namespace: 'pomerium',
    },
    spec: {
      secretName: 'pomerium-tls',
      issuerRef: {
        name: lib.getElse(config, 'certmanager.issuer', 'letsencrypt-production'),
        kind: 'ClusterIssuer',
      },
      commonName: names[0],
      dnsNames: names,
    },
  }
);

function(config, prev) certificate(config)

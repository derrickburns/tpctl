local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import '../../lib/pom.jsonnet';

local dnsNames(config, namespace) = (
  local domain = mylib.rootDomain(config);
  [
    'authenticate.%s' % domain,
    'authorize.%s' % domain,
  ]
  + mylib.dnsNames(config)
);

local certificate(config, namespace) = k8s.k('cert-manager.io/v1alpha2', 'Certificate') + k8s.metadata('pomerium-certificate', namespace) + (
  local names = dnsNames(config, namespace);
  {
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

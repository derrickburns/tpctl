local lib = import '../../lib/lib.jsonnet';

local dnsNames(config) = (
  local pkgs = config.pkgs;
  [
    pkgs[x].sso.dnsName
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso.dnsName', '') != ''
  ] +
  [
    'authenticate.%s' % config.pkgs.pomerium.rootDomain,
    'authorize.%s' % config.pkgs.pomerium.rootDomain,
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

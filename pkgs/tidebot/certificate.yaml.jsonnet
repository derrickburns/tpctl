local lib=import '../../lib/lib.jsonnet';

local certificate(config) = {
  local e = config.pkgs.tidebot,

  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'Certificate',
  metadata: {
    name: e.service.https.dnsNames[0],
    namespace: lib.getElse(e, 'namespace', 'tidebot'),
  },
  spec: {
    secretName: lib.getElse(e, 'certificate.secret', 'tls'),
    issuerRef: {
      name: lib.getElse(e, 'certificate.issuer', 'letsencrypt-production'),
      kind: 'ClusterIssuer',
    },
    commonName: e.service.https.dnsNames[0],
    dnsNames: e.service.https.dnsNames,
  },
};

function(config) 
  if isTrue(config, 'servive.https.enabled')
  then certificate(config)
  else {};

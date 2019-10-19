local lib=import '../../lib/lib.jsonnet';

local certificate(config) = {
  local e = config.pkgs.tidebot.ingress,

  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'Certificate',
  metadata: {
    name: e.gateway.https.dnsNames[0],
    namespace: lib.getElse(e, 'namespace', 'tidebot'),
  },
  spec: {
    secretName: lib.getElse(e, 'certificate.secretName', 'tls'),
    issuerRef: {
      name: lib.getElse(e, 'certificate.issuer', 'letsencrypt-production'),
      kind: 'ClusterIssuer',
    },
    commonName: e.gateway.https.dnsNames[0],
    dnsNames: e.gateway.https.dnsNames,
  },
};

function(config) 
  if lib.isTrue(config, 'pkgs.tidebot.ingress.service.https.enabled')
  then certificate(config)
  else {}

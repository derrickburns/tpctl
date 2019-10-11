local certificate(config, namespace) = {
  local e = config.environments[namespace].tidepool,

  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'Certificate',
  metadata: {
    name: e.gateway.https.dnsNames[0],
    namespace: namespace,
  },
  spec: {
    secretName: e.certificate.secret,
    issuerRef: {
      name: e.certificate.issuer,
      kind: 'ClusterIssuer',
    },
    commonName: e.gateway.https.dnsNames[0],
    dnsNames: e.gateway.https.dnsNames,
  },
};

function(config, prev, namespace) certificate(config, namespace)

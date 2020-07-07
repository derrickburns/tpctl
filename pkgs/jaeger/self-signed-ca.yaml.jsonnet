local certmanager = import '../../lib/certmanager.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local caIssuer(me) = {
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'Issuer',
  metadata: {
    name: 'ca-issuer',
    namespace: me.namespace,
  },
  spec: {
    selfSigned: {},
  },
};

local caCert(me) = certmanager.certificate(me, ['tracing.svc.cluster.local'], issuer='self-signed-issuer') {
  metadata+: {
    name: 'tracing-ca',
    namespace: me.namespace,
  },
  spec+: {
    isCA: true,
    dnsNames: [],
    usages: [
      'server auth',
      'client auth',
    ],
    secretName: 'tracing-ca-tls',
    issuerRef: {
      name: 'ca-issuer',
    },
  },
};

local selfSignedIssuer(me) = {
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'Issuer',
  metadata: {
    name: 'self-signed-issuer',
    namespace: me.namespace,
  },
  spec: {
    ca: {
      secretName: 'tracing-ca-tls',
    },
  },
};

local esCert(me) = certmanager.certificate(me, ['elasticsearch', 'elasticsearch.tracing.svc.cluster.local'], issuer='self-signed-issuer') {
  spec+: {
    isCA: false,
    usages: [
      'server auth',
      'client auth',
    ],
    secretName: 'elasticsearch-tls',
    issuerRef: {
      name: 'self-signed-issuer',
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    caIssuer(me),
    caCert(me),
    selfSignedIssuer(me),
    esCert(me),
  ]
)

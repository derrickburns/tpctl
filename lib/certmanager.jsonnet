local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';

{
  certificate(me, dnsNames, secretName=''):: {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'Certificate',
    metadata: {
      name: std.strReplace(dnsNames[0], '*', 'star'),
      namespace: me.namespace,
    },
    spec: {
      secretName: if secretName == '' then '%s-tls' %  me.pkg else secretName,
      issuerRef: {
        name: lib.getElse(global.package(me.config, 'certmanager'), 'issuer', 'letsencrypt-production'),
        kind: 'ClusterIssuer',
      },
      commonName: dnsNames[0],
      dnsNames: dnsNames,
    },
  },
}

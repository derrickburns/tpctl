local lib = import 'lib.jsonnet';
local global = import 'global.jsonnet';

{
  certificate(config, secretName, namespace, dnsNames):: {
      apiVersion: 'cert-manager.io/v1alpha2',
      kind: 'Certificate',
      metadata: {
        name: std.strReplace(dnsNames[0], '*', 'star'),
        namespace: namespace,
      },
      spec: {
        secretName: secretName,
        issuerRef: {
          name: lib.getElse(global.package(config, 'certmanager'), 'issuer', 'letsencrypt-production'),
          kind: 'ClusterIssuer',
        },
        commonName: dnsNames[0],
        dnsNames: dnsNames,
      },
    }
}

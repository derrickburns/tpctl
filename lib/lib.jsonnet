{
  get(x, path, sep='.'):: (
    local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
    std.foldl(foldFunc, std.split(path, sep), x)
  ),

  getElse(x, path, default):: (
    local found = $.get(x, path);
    if found == null then default else found
  ),

  isEq(x, path, y):: $.get(x, path) == y,

  isTrue(x, path):: $.isEq(x, path, true),

  dnsNames(config):: (
    local e = $.get(config, 'environments');
    local tp =
      if e == null
      then []
      else (
        local envs = std.objectFields(e);
        [e[env].tidepool for env in envs if $.isTrue(e[env], 'tidepool.enabled')]
      );

    local p = $.get(config, 'pkgs');
    local pk =
      if p == null
      then []
      else (
        local pkgs = std.objectFields(p);
        [p[pkg] for pkg in pkgs if $.isTrue(p[pkg], 'enabled')]
      );

    local all = tp + pk;
    local httpNames = [x.ingress.gateway.http.dnsNames for x in all if $.isTrue(x, 'ingress.service.http.enabled')];
    local httpsNames = [x.ingress.gateway.https.dnsNames for x in all if $.isTrue(x, 'ingress.service.https.enabled')];
    std.join(',', std.filter(function(x) x != 'localhost', std.flattenArrays(httpNames + httpsNames)))
  ),

  certificate(e, namespace):: {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'Certificate',
    metadata: {
      name: e.gateway.https.dnsNames[0],
      namespace: namespace,
    },
    spec: {
      secretName: $.getElse(e, 'certificate.secretName', 'tls'),
      issuerRef: {
        name: $.getElse(e, 'certificate.issuer', 'letsencrypt-production'),
        kind: 'ClusterIssuer',
      },
      commonName: e.gateway.https.dnsNames[0],
      dnsNames: e.gateway.https.dnsNames,
    },
  },
}

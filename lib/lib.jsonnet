{
  environments(config):: (
    local e = $.get(config, 'environments');
    if e == null
    then []
    else (
      local envs = std.objectFields(e);
      [env for env in envs if $.isTrue(e[env], 'tidepool.enabled')]
    )
  ),
  virtualServices(config, name):: [
    {
      name: name,
      namespace: e,
    }
    for e in lib.environments(config)
  ],
  dnsNames(config):: (
    local tp = [config.environments[env].tidepool for env in $.environments(config)];
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
  contains(list, value):: std.foldl(function(a, b) (a || (b == value)), list, false),

  pruneList(list):: std.foldl(function(a, b) if b == null then a else a + [b], list, []),

  // return a list of the fields of the object given
  values(obj):: [obj[field] for field in std.objectFields(obj)],

  // return a clone without the given field
  ignore(x, exclude):: { [f]: x[f] for f in std.objectFieldsAll(x) if f != exclude },

  present(x, path):: $.get(x, path) != null,

  remapKey(x, remap, key='resources')::
    if $.present(x, key)
    then { [key]+: std.mapWithKey(remap, x[key]) }
    else {},

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

  mergeList(list):: std.foldl($.merge, list, {}),

  // merge two objects recursively, choose b for non-object parameters
  merge(a, b)::
    if (std.isObject(a) && std.isObject(b))
    then (
      {
        [x]: a[x]
        for x in std.objectFieldsAll(a)
        if !std.objectHas(b, x)
      } + {
        [x]: b[x]
        for x in std.objectFieldsAll(b)
        if !std.objectHas(a, x)
      } + {
        [x]: $.merge(a[x], b[x])
        for x in std.objectFieldsAll(b)
        if std.objectHas(a, x)
      }
    )
    else b,

  // strip the object of any field or subfield whose name is in given list
  strip(obj, list)::
    { [k]: obj[k] for k in std.objectFieldsAll(obj) if !$.contains(list, k) && !std.isObject(obj[k]) } +
    { [k]: $.strip(obj[k], list) for k in std.objectFieldsAll(obj) if !$.contains(list, k) && std.isObject(obj[k]) },


}

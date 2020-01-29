{
  environments(config):: (
    local e = $.getElse(config, 'environments', {});
    local envs = std.objectFields(e);
    { [env]: $.withName($.withNamespace(e[env].tidepool, env), env) for env in envs if $.isTrue(e[env], 'tidepool.enabled') }
  ),

  packages(config):: (
    local p = $.getElse(config, 'pkgs', {});
    local pkgs = std.objectFields(p);
    { [pkg]: $.withNamespace(p[pkg], pkg) for pkg in pkgs if $.isEnabled(p[pkg]) }
  ),

  isEnabled(x):: $.isTrue(x, 'enabled'),

  withDefault(obj, field, default)::
    if obj == null || std.objectHas(obj, field)
    then obj
    else obj { [field]: default },

  // add a default namespace to an object if it does not have one
  withNamespace(obj, default):: $.withDefault(obj, 'namespace', default),

  // add a default name to an object if it does not have one
  withName(obj, default):: $.withDefault(obj, 'name', default),

  propagate(c, key, field):: c {
    [key]: { [env]: $.withDefault(c[key][env], field, env) for env in std.objectFields(c[key]) },
  },

  complete(config):: $.propagate($.propagate(config, 'environments', 'namespace'), 'pkgs', 'namespace'),

  rootDomain(config):: $.getElse(config, 'pkgs.pomerium.rootDomain', config.cluster.metadata.domain),

  // provide an array of virtual services for a config
  virtualServices(config):: (
    $.virtualServicesForPkgs($.environments(config)) +
    $.virtualServicesForPkgs($.packages(config))
  ),

  // provide array of virtual service maps for array of packages
  virtualServicesForPkgs(pkgs)::
    std.flattenArrays($.values(std.mapWithKey($.virtualServicesForPkg, pkgs))),

  // provide array of virtual service maps for package
  // use the name of the package as the namespace if the namespace is not explicitly declared
  // use the key of the virtual service object as the name of the virtual service
  virtualServicesForPkg(name, pkg)::
    $.pruneList($.virtualServicesToList($.getElse(pkg, 'virtualServices', {}), $.getElse(pkg, 'namespace', name))),

  // flatten a map after adding name and namespace fields
  virtualServicesToList(map, ns):: std.filter(function(x) $.getElse(x, 'enabled', false), $.values($.addName($.addNamespace(map, ns)))),

  // add namespace field to each object under a map if it does not already have one
  addNamespace(map, ns):: std.mapWithKey(function(n, v) $.withNamespace(v, ns), map),

  // add a name field to each entry of a map, where the name is the key
  addName(map):: std.mapWithKey(function(n, v) $.withName(v, n), map),

  namespace(config, pkg):: $.getElse(config, 'pkgs.' + pkg + '.namespace', pkg),

  matches(labels, selector)::
    std.foldl(function(a, b) a && b, [$.getElse(labels, x, false) == selector[x] for x in std.objectFields(selector)], true),

  // We are awaiting a change in Gloo to allow Gateways to select virtual services
  // across namespaces using labels. For now, we simulate that behavior here.
  //
  virtualServicesForSelector(vss, selector)::
    std.filter(function(x) $.matches(x.labels, selector), vss),

  defaultPort(protocol):: if protocol == 'http' then 80 else 443,

  bindPort(protocol):: 8000 + $.defaultPort(protocol),

  domainFrom(name, port, default)::
    if name == '*'
    then '*'
    else if port != default then '%s:%s' % [name, port] else name,

  protocol(vs):: vs.labels.protocol,

  port(vs):: (
    local protocol = $.protocol(vs);
    local default = $.defaultPort(protocol);
    $.getElse(vs, 'port', default)
  ),

  domains(vs):: (
    local port = $.port(vs);
    local protocol = $.protocol(vs);
    local default = $.defaultPort(protocol);
    [$.domainFrom(name, port, default) for name in $.getElse(vs, 'dnsNames', [])]
  ),

  sslConfig(vs):: if $.getElse(vs, 'labels.protocol', 'http') == 'https' then {
    sslConfig: {
      secretRef: {
        name: $.certificateSecretName(vs.name),
        namespace: vs.namespace,
      },
      sniDomains: $.getElse(vs, 'dnsNames', []),
    },
  } else {},

  route(vs)::
    if std.objectHas(vs, 'redirect') then {
      redirectAction: {
        httpsRedirect: true,
      },
    } else if std.objectHas(vs, 'delegateAction') then {
      delegateAction: {
        namespace: vs.namespace,
        name: vs.delegateAction,
      },
    } else if std.objectHas(vs, 'routeAction') then {
      routeAction: vs.routeAction,
    } else {
      routeAction: {
        single: {
          kube: {
            ref: {
              name: vs.name,
              namespace: vs.namespace,
            },
            port: 8080,
          },
        },
      },
    },

  options: {
    cors: {
      allowCredentials: true,
      allowHeaders: [
        'authorization',
        'content-type',
        'x-tidepool-session-token',
        'x-tidepool-trace-request',
        'x-tidepool-trace-session',
      ],
      allowMethods: [
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS',
      ],
      allowOriginRegex: [
        '.*',
      ],
      exposeHeaders: [
        'x-tidepool-session-token',
        'x-tidepool-trace-request',
        'x-tidepool-trace-session',
      ],
      maxAge: '600s',
    },
    headerManipulation: {
      requestHeadersToAdd: [
        {
          header: {
            key: 'Strict-Transport-Security',
            value: 'max-age=31536000',
          },
        },
      ],
    },
  },

  virtualService(vsin, defaultName, defaultNamespace, options=null):: {
    local vs = $.withNamespace($.withName(vsin, defaultName), defaultNamespace),
    local procotol = vs.labels.protocol,
    apiVersion: 'gateway.solo.io/v1',
    kind: 'VirtualService',
    metadata: {
      name: $.kebabCase(vs.name),
      namespace: vs.namespace,
      labels: vs.labels,
    },
    spec: $.sslConfig(vs) + {
      displayName: $.kebabCase(vs.name),
      virtualHost: {
        domains: $.domains(vs),
        routes: [
          {
            matchers: [{ prefix: '/' }],
          } + $.route(vs),
        ],
        options: lib.getElse(vs, 'options', {}) + (if vs.labels.type == 'external' && vs.labels.protocol == 'https' then options else {}),
      },
    },
  },

  gateways(config):: (
    local vss = $.virtualServices(config);
    local gloo = $.withNamespace(config.pkgs.gloo, 'gloo-system');
    local gws = $.values(std.mapWithKey(function(n, v) $.withName(v, n), gloo.gateways));
    [$.gateway($.withNamespace(gw, gloo.namespace), vss) for gw in gws]
  ),

  dnsNames(config):: (
    local vss = $.virtualServices(config);
    local externalVss = $.virtualServicesForSelector(vss, { type: 'external' });
    std.uniq(std.sort(std.flattenArrays(std.map(function(vs) $.getElse(vs, 'dnsNames', []), externalVss))))
  ),

  accessLoggingOption:: {
    accessLoggingService: {
      accessLog: [
        {
          fileSink: {
            jsonFormat: {
              authority: '%REQ(:authority)%',
              authorization: '%REQ(authorization)%',
              content: '%REQ(content-type)%',
              duration: '%DURATION%',
              forwardedFor: '%REQ(X-FORWARDED-FOR)%',
              method: '%REQ(:method)%',
              path: '%REQ(:path)%',
              remoteAddress: '%DOWNSTREAM_REMOTE_ADDRESS_WITHOUT_PORT%',
              request: '%REQ(x-tidepool-trace-request)%',
              response: '%RESPONSE_CODE%',
              scheme: '%REQ(:scheme)%',
              session: '%REQ(x-tidepool-trace-session)%',
              startTime: '%START_TIME%',
              token: '%REQ(x-tidepool-session-token)%',
              upstream: '%UPSTREAM_CLUSTER%',
            },
            path: '/dev/stdout',
          },
        },
      ],
    },
  },

  httpConnectionManagerOption:: {
    httpConnectionManagerSettings: {
      useRemoteAddress: true,
      tracing: {
        verbose: true,
        requestHeadersForTags: ['path', 'origin'],
      },
    },
  },

  healthCheckOption:: {
    healthCheck: {
      path: '/status',
    },
  },

  gateway(gw, vss):: {
    apiVersion: 'gateway.solo.io/v1',
    kind: 'Gateway',
    metadata: {
      annotations: {
        origin: 'default',
      },
      name: gw.name,
      namespace: gw.namespace,
    },
    spec: {
      httpGateway: {
        virtualServiceSelector: gw.selector,
        virtualServiceNamespaces: ['*'],
        options:
          (if $.getElse(gw, 'options.healthCheck', false) then $.healthCheckOption else {})
          + (if $.getElse(gw, 'options.tracing', false) then $.httpConnectionManagerOption else {}),
      },
      options: if $.getElse(gw, 'options.accessLogging', false) then $.accessLoggingOption else {},
      bindAddress: '::',
      bindPort: $.bindPort(gw.selector.protocol),
      proxyNames: gw.proxies,
      useProxyProto: $.getElse(gw, 'options.proxyProtocol', false),
      ssl: $.getElse(gw, 'options.ssl', false),
    },
  },

  service(config, pkg):: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: pkg,
      namespace: $.namespace(config, pkg),
    },
    spec: {
      type: 'ClusterIP',
      ports: [{
        name: 'http',
        protocol: 'TCP',
        port: 8080,
        targetPort: 8080,
      }],
      selector: {
        name: pkg,
      },
    },
  },

  virtualServicesForPackage(config, pkgname):: (
    local vsarray = $.virtualServicesForPkg(pkgname, config.pkgs[pkgname]);
    std.map(function(v) $.virtualService(v, v.name, $.namespace(config, pkgname)), vsarray)
  ),

  virtualServicesForEnvironment(config, envname):: (
    local vsarray = $.virtualServicesForPkg(envname, config.environments[envname].tidepool);
    std.map(function(v) $.virtualService(v, v.name, envname, $.options), vsarray)
  ),

  certificatesForPackage(config, pkgname):: (
    local vsarray = $.virtualServicesForPkg(pkgname, config.pkgs[pkgname]);
    std.map(function(v) $.certificate(config, v, v.name, $.namespace(config, pkgname)), vsarray)
  ),

  certificatesForEnvironment(config, envname):: (
    local vsarray = $.virtualServicesForPkg(envname, config.environments[envname].tidepool);
    $.pruneList(std.map(function(v) $.certificate(config, v, v.name, envname), vsarray))
  ),

  certificateSecretName(base):: base + '-certificate',

  certificate(config, vsin, defaultName, defaultNamespace):: (
    local vs = $.withNamespace($.withName(vsin, defaultName), defaultNamespace);
    if $.getElse(config, 'pkgs.certmanager.enabled', false) && $.getElse(vsin, 'labels.protocol', 'http') == 'https'
    then {
      apiVersion: 'cert-manager.io/v1alpha2',
      kind: 'Certificate',
      metadata: {
        name: std.strReplace(vs.dnsNames[0], '*', 'star'),
        namespace: vs.namespace,
      },
      spec: {
        secretName: $.certificateSecretName(vs.name),
        issuerRef: {
          name: $.getElse(config, 'certmanager.issuer', 'letsencrypt-production'),
          kind: 'ClusterIssuer',
        },
        commonName: vs.dnsNames[0],
        dnsNames: vs.dnsNames,
      },
    }
    else {}
  ),

  contains(list, value):: std.foldl(function(a, b) (a || (b == value)), list, false),

  pruneList(list):: std.foldl(function(a, b) if b == null || b == {} then a else a + [b], list, []),

  // return a list of the fields of the object given
  values(obj):: [obj[field] for field in std.objectFields(obj)],

  // return a clone without the given field
  ignore(x, exclude):: { [f]: x[f] for f in std.objectFieldsAll(x) if f != exclude },

  present(x, path):: $.get(x, path) != null,

  manifestJsonFields(obj):: {
    [k]: std.manifestJson(obj[k])
    for k in std.objectFields(obj)
  },

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

  isUpper(c):: (
    local cp = std.codepoint(c);
    cp >= 65 && cp <= 90
  ),

  capitalize(word):: (
    assert std.isString(word) : 'can only capitalize string';
    assert std.length(word) > 0 : 'cannot capitalize empty string';
    local chars = std.stringChars(word);
    std.asciiUpper(chars[0]) + std.foldl(function(a, b) a + b, chars[1:std.length(chars)], '')
  ),

  kebabCase(camelCaseWord):: (
    local merge(a, b) = {
      local isUpper = $.isUpper(b),
      word: (if (isUpper && !a.wasUpper) then '%s-%s' else '%s%s') % [a.word, std.asciiLower(b)],
      wasUpper: isUpper,
    };
    std.foldl(merge, std.stringChars(camelCaseWord), { word: '', wasUpper: true }).word
  ),

  camelCase(kebabCaseWord, initialUpper=false):: (
    local merge(a, b) = {
      local isHyphen = (b == '-'),
      word: if isHyphen then a.word else a.word + (if a.toUpper then std.asciiUpper(b) else b),
      toUpper: isHyphen,
    };
    std.foldl(merge, std.stringChars(kebabCaseWord), { word: '', toUpper: initialUpper }).word
  ),

  pascalCase(kebabCaseWord):: $.camelCase(kebabCaseWord, true),
}

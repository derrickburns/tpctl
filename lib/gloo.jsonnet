local lib = import 'lib.jsonnet';

{
  // provide an array of virtual services for a config
  virtualServices(config):: (
    $.virtualServicesForPkgs(lib.environments(config)) +
    $.virtualServicesForPkgs(lib.packages(config))
  ),

  // provide array of virtual service maps for array of packages
  virtualServicesForPkgs(pkgs)::
    std.flattenArrays(lib.values(std.mapWithKey($.virtualServicesForPkg, pkgs))),

  // provide array of virtual service maps for package
  // use the name of the package as the namespace if the namespace is not explicitly declared
  // use the key of the virtual service object as the name of the virtual service
  virtualServicesForPkg(name, pkg)::
    lib.pruneList($.virtualServicesToList(lib.getElse(pkg, 'virtualServices', {}), lib.getElse(pkg, 'namespace', name))),

  // flatten a map after adding name and namespace fields
  virtualServicesToList(map, ns):: std.filter(function(x) lib.getElse(x, 'enabled', false), lib.values(lib.addName(lib.addNamespace(map, ns)))),

  virtualServicesForSelector(vss, selector)::
    std.filter(function(x) lib.matches(x.labels, selector), vss),

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
    lib.getElse(vs, 'port', default)
  ),

  domains(vs):: (
    local port = $.port(vs);
    local protocol = $.protocol(vs);
    local default = $.defaultPort(protocol);
    [$.domainFrom(name, port, default) for name in lib.getElse(vs, 'dnsNames', [])]
  ),

  isHttps(vs):: lib.getElse(vs, 'labels.protocol', 'http') == 'https',

  sslConfig(vs):: if $.isHttps(vs) then {
    sslConfig: {
      secretRef: {
        name: $.certificateSecretName(vs.name),
        namespace: vs.namespace,
      },
      sniDomains: lib.getElse(vs, 'dnsNames', []),
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
      options: if std.objectHas(vs, 'timeout') then { timeout: vs.timeout, } else {},
      routeAction: vs.routeAction,
    } else {
      options: if std.objectHas(vs, 'timeout') then { timeout: vs.timeout, } else {},
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

  virtualHostOptions: {
    cors: {
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
    },
    hsts: {
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
  },

  virtualService(vsin, defaultName, defaultNamespace):: {
    local vs = lib.withNamespace(lib.withName(vsin, defaultName), defaultNamespace),
    local procotol = vs.labels.protocol,
    apiVersion: 'gateway.solo.io/v1',
    kind: 'VirtualService',
    metadata: {
      name: lib.kebabCase(vs.name),
      namespace: vs.namespace,
      labels: vs.labels,
    },
    spec: $.sslConfig(vs) + {
      displayName: lib.kebabCase(vs.name),
      virtualHost: {
        domains: $.domains(vs),
        routes: [
          {
            matchers: [{ prefix: '/' }],
          } + $.route(vs),
        ],
        options: lib.getElse(vs, 'options', {})
          + (if lib.isTrue(vs, 'cors.enabled') then $.virtualHostOptions.cors else {})
          + (if lib.isTrue(vs, 'hsts.enabled') then $.virtualHostOptions.hsts else {})
      },
    },
  },

  gateways(config):: (
    local vss = $.virtualServices(config);
    local gloo = lib.withNamespace(config.pkgs.gloo, 'gloo-system');
    local gws = lib.values(std.mapWithKey(function(n, v) lib.withName(v, n), gloo.gateways));
    [$.gateway(lib.withNamespace(gw, gloo.namespace), vss) for gw in gws]
  ),

  dnsNames(config, selector={ type: 'external'}):: (
    local vss = $.virtualServices(config);
    local externalVss = $.virtualServicesForSelector(vss, selector);
    std.uniq(std.sort(std.flattenArrays(std.map(function(vs) lib.getElse(vs, 'dnsNames', []), externalVss))))
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
              bytesReceived: '%BYTES_RECEIVED%',
              responseCodeDetail: '%RESPONSE_CODE_DETAILS%',
              requestDuration: '%REQUEST_DURATION%',
              responseFlags: '%RESPONSE_FLAGS%',
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
          (if lib.getElse(gw, 'options.healthCheck', false) then $.healthCheckOption else {})
          + (if lib.getElse(gw, 'options.tracing', false) then $.httpConnectionManagerOption else {}),
      },
      options: if lib.getElse(gw, 'options.accessLogging', false) then $.accessLoggingOption else {},
      bindAddress: '::',
      bindPort: $.bindPort(gw.selector.protocol),
      proxyNames: gw.proxies,
      useProxyProto: lib.getElse(gw, 'options.proxyProtocol', false),
      ssl: lib.getElse(gw, 'options.ssl', false),
    },
  },

  service(config, pkg):: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: pkg,
      namespace: lib.namespace(config, pkg),
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
    std.map(function(v) $.virtualService(v, v.name, lib.namespace(config, pkgname)), vsarray)
  ),

  virtualServicesForEnvironment(config, envname):: (
    local vsarray = $.virtualServicesForPkg(envname, config.environments[envname].tidepool);
    std.map(function(v) $.virtualService(v, v.name, envname), vsarray)
  ),

  certificatesForPackage(config, pkgname):: (
    local vsarray = $.virtualServicesForPkg(pkgname, config.pkgs[pkgname]);
    std.map(function(v) $.certificate(config, v, v.name, lib.namespace(config, pkgname)), vsarray)
  ),

  certificatesForEnvironment(config, envname):: (
    local vsarray = $.virtualServicesForPkg(envname, config.environments[envname].tidepool);
    lib.pruneList(std.map(function(v) $.certificate(config, v, v.name, envname), vsarray))
  ),

  certificateSecretName(base):: base + '-certificate',

  certificate(config, vsin, defaultName, defaultNamespace):: (
    local vs = lib.withNamespace(lib.withName(vsin, defaultName), defaultNamespace);
    if lib.getElse(config, 'pkgs.certmanager.enabled', false) && $.isHttps(vsin)
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
          name: lib.getElse(config, 'certmanager.issuer', 'letsencrypt-production'),
          kind: 'ClusterIssuer',
        },
        commonName: vs.dnsNames[0],
        dnsNames: vs.dnsNames,
      },
    }
    else {}
  ),
}

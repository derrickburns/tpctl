local lib = import 'lib.jsonnet';
local k8s = import 'k8s.jsonnet';
local certmanager = import 'certmanager.jsonnet';

{
  vsForNamespacedPackage(name, pkg, package):: (

    // add virtual service name and namespace as key/value pairs in each virtual service
    local taggedVsList(vsmap) = lib.addName(lib.addNamespace(vsmap, name));

    // flatten tagged virtual service map into a simple list
    local taggedVsMap(vsmap) = lib.values(taggedVsList(vsmap));

    // filter out disabled virtual services
    local enabledVsList(vsmap) =
      lib.pruneList(std.filter(function(vs) lib.isEnabled(vs), taggedVsMap(vsmap)));

    // filter out disabled packages
    std.filter(
      function(x) lib.isEnabled(package),
      enabledVsList(lib.getElse(package, 'virtualServices', {}))
    )
  ),

  // provide an array of virtual services for a config
  virtualServices(config):: (
    local vsForNamespace(name, namespace) = (
      local vsForPackage(pkg, package) = $.vsForNamespacedPackage(name, pkg, package);
      std.flattenArrays(lib.values(std.mapWithKey(vsForPackage, namespace)))
    );
    std.flattenArrays(lib.values(std.mapWithKey(vsForNamespace, config.namespaces)))
  ),

  // flatten a map after adding name and namespace fields

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

  routeOptions(vs):: lib.getElse(vs, 'routeOptions', {}),

  routes(vs):: [
    { matchers: [{ prefix: '/' }] } + $.route(vs) + { options+: $.routeOptions(vs) },
  ],

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
      options: if std.objectHas(vs, 'timeout') then { timeout: vs.timeout } else {},
      routeAction: vs.routeAction,
    } else {
      options: if std.objectHas(vs, 'timeout') then { timeout: vs.timeout } else {},
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

  staticVirtualHostOptions: {
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

  virtualHostOptions(vs):: lib.getElse(vs, 'virtualHostOptions', {})
                           + (if lib.isTrue(vs, 'cors.enabled') then $.staticVirtualHostOptions.cors else {})
                           + (if lib.isTrue(vs, 'hsts.enabled') then $.staticVirtualHostOptions.hsts else {}),

  virtualHost(vs):: {
    domains: $.domains(vs),
    routes: $.routes(vs),
    options: $.virtualHostOptions(vs),
  },

  virtualService(vsin, defaultName, defaultNamespace):: {
    local vs = lib.withNamespace(lib.withName(vsin, defaultName), defaultNamespace),
    apiVersion: 'gateway.solo.io/v1',
    kind: 'VirtualService',
    metadata: {
      name: lib.kebabCase(vs.name),
      namespace: vs.namespace,
      labels: vs.labels,
    },
    spec: $.sslConfig(vs) + {
      displayName: lib.kebabCase(vs.name),
      virtualHost: $.virtualHost(vs),
    },
  },

  gateways(config):: (
    local vss = $.virtualServices(config);
    local gloo = lib.withNamespace(config.pkgs.gloo, 'gloo-system');
    local gws = lib.values(std.mapWithKey(function(n, v) lib.withName(v, n), gloo.gateways));
    [$.gateway(lib.withNamespace(gw, gloo.namespace), vss) for gw in gws]
  ),

  dnsNames(config, selector={ type: 'external' }):: (
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
    metadata+: {
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

  virtualServicesForPackage(config, pkgname, namespace):: (
    local vsarray = $.vsForNamespacedPackage(namespace, pkgname, config.namespaces[namespace][pkgname]);
    local tovs(x) = $.virtualService(x, pkgname, namespace);
    local result = std.map(tovs,  vsarray);
    std.filter( function(x) std.length(x.spec.virtualHost.domains) > 0, result )
  ),

  certificatesForPackage(config, pkgname, namespace):: (
    local vsarray = $.vsForNamespacedPackage(namespace, pkgname, config.namespaces[namespace][pkgname]);
    lib.pruneList(std.map(function(v) $.certificate(config, v, pkgname, namespace), vsarray))
  ),

  certificateSecretName(base):: base + '-certificate',

  certificate(config, vsin, defaultName, defaultNamespace):: (
    local vs = lib.withNamespace(lib.withName(vsin, defaultName), defaultNamespace);
    if lib.getElse(config, 'pkgs.certmanager.enabled', false)
       && $.isHttps(vs)
       && std.length(vs.dnsNames) > 0
    then certmanager.certificate(config, $.certificateSecretName(vs.name), vs.namespace, vs.dnsNames)
    else {}
  ),
}

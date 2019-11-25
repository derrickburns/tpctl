{
  environments(config):: (
    local e = $.getElse(config, 'environments', {});
    local envs = std.objectFields(e);
    { [env]: e[env].tidepool for env in envs if $.isTrue(e[env], 'tidepool.enabled') }
  ),

  packages(config):: (
    local p = $.getElse(config, 'pkgs', {});
    local pkgs = std.objectFields(p);
    { [pkg]: p[pkg] for pkg in pkgs if $.isEnabled(p[pkg]) }
  ),

  isEnabled(x):: $.isTrue(x, 'enabled'),

  // select all ingress sub-objects across the entire configuration
  ingresses(config):: (
    local envs = $.environments(config);
    local pkgs = $.packages(config);
    std.mapWithKey(function(n, v) $.getElse(v, 'ingress', null), envs)
    + std.mapWithKey(function(n, v) $.getElse(v, 'spec.values.ingress', null), pkgs)
  ),

  // filter ingresses by name
  ingressesForGateway(ingresses, gateway)::
    std.mapWithKey(
      function(n, v)
        if $.isTrue(v, 'service.' + gateway + '.enabled') then v else null,
      ingresses
    ),

  vsName(protocol, isInternal):: if isInternal then protocol + '-internal' else protocol,

  gatewayName(protocol, isInternal):: (
    local tail = if protocol == 'http' then 'gateway-proxy' else 'gateway-proxy-ssl';
    local head = if isInternal then 'internal-' else '';
    head + tail
  ),

  namespace(config, pkg) :: $.getElse(config, 'pkgs.' + pkg + '.namespace', pkg),


  // We are awaiting a change in Gloo to allow Gateways to select virtual services
  // across namespaces using labels.
  //
  // Until then, we select virtual services for a gateway using the convention that
  // the name of the virtual service is the name of the gateway that includes it.
  virtualServices(config, protocol, isInternal):: (
    local ingresses = $.ingresses(config);
    local gateway = $.vsName(protocol, isInternal);
    $.pruneList($.values(
      std.mapWithKey(
        function(n, v) 
          if v != null
          then { name: gateway, namespace: $.namespace(config,n) }
          else null,
          $.ingressesForGateway(ingresses, gateway)
      )
    ))
  ),

  proxyName(isInternal):: if isInternal then 'internal-gateway-proxy' else 'gateway-proxy',

  defaultPort(protocol):: if protocol == 'http' then 80 else 443,

  bindPort(protocol):: 8000 + $.defaultPort(protocol),

  domainFrom(name, port, default)::
    if name == '*'
    then '*'
    else if port != default then '%s:%s' % [name, port] else name,

  port(ingress, protocol):: (
    local gateway = ingress.gateway[protocol];
    local default = $.defaultPort(protocol);
    $.getElse(gateway, 'port', default)
  ),

  domains(gateway, protocol):: (
    local port = $.port(gateway, protocol);
    local default = $.defaultPort(protocol);
    [$.domainFrom(name, port, default) for name in gateway.dnsNames]
  ),

  sslConfig(ingress, namespace):: {
    sslConfig: {
      secretRef: {
        name: $.getElse(ingress, 'certificate.secretName', 'tls'),
        namespace: namespace,
      },
    },
    sniDomains: ingress.gateway.https.dnsNames,
  },

  virtualService(name, namespace, ingress, protocol):: {
    apiVersion: 'gateway.solo.io/v1',
    kind: 'VirtualService',
    metadata: {
      name: protocol,
      namespace: namespace,
    },
    spec: {
      displayName: protocol,
      virtualHost: (if protocol == 'https' then $.sslConfig(ingress, namespace) else {}) + {
        domains: $.domains(ingress.gateway, protocol),
        routes: [
          {
            matchers: [
              {
                prefix: '/',
              },
            ],
            routeAction: {
              single: {
                kube: {
                  ref: {
                    name: name,
                    namespace: namespace,
                  },
                  port: $.port(ingress, protocol),
		},
              },
            },
          },
        ],
      },
    },
  },

  gateway(config, protocol, isInternal):: {
    apiVersion: 'gateway.solo.io/v1',
    kind: 'Gateway',
    metadata: {
      annotations: {
        origin: 'default',
      },
      name: $.gatewayName(protocol, isInternal),
      namespace: $.getElse(config, 'pkgs.gloo.namespace', 'gloo-system'),
    },
    spec: {
      httpGateway: {
        virtualServices: $.virtualServices(config, protocol, isInternal),
        options: {
          httpConnectionManagerSettings: {
            useRemoteAddress: true,
            tracing: {
              verbose: true,
              requestHeadersForTags: ['path', 'origin'],
            },
          },
          healthCheck: {
            path: '/status',
          },
        },
      },
      options: {
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
      bindAddress: '::',
      bindPort: $.bindPort(protocol),
      proxyNames: [
        $.proxyName(isInternal),
      ],
      useProxyProto: !isInternal,
      ssl: protocol == 'https',
    },
  },

  protocols(ingress):: [ x for x in std.objectFields(ingress.gateway) if $.getElse(ingress.service[x], 'enabled')],

  dnsNames(config):: (
    local ingresses = $.ingresses(config);

    local httpNames = [x.gateway.http.dnsNames for x in $.pruneList($.values($.ingressesForGateway(ingresses, 'http')))];
    local httpsNames = [x.gateway.https.dnsNames for x in $.pruneList($.values($.ingressesForGateway(ingresses, 'https')))];
    std.join(',', std.filter(function(x) x != 'localhost', std.flattenArrays(httpNames + httpsNames)))
  ),

  ports(ingress) :: [
    {
      name: protocol,
      protocol: "TCP",
      port: $.port(ingress, protocol),
      targetPort: $.bindPort(protocol),
    } for protocol in $.protocols(ingress)
  ],

  service(config, pkg):: {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: pkg,
      namespace: $.namespace(config, pkg),
    },
    spec: {
      type: "ClusterIP",
      ports: $.ports(config.pkgs[pkg].spec.values.ingress),
      selector: {
        name: pkg,
        namespace: $.namespace(config, pkg),
      }
    }
  },

  certificate(ingress, namespace):: {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'Certificate',
    metadata: {
      name: ingress.gateway.https.dnsNames[0],
      namespace: namespace,
    },
    spec: {
      secretName: $.getElse(ingress, 'certificate.secretName', 'tls'),
      issuerRef: {
        name: $.getElse(ingress, 'certificate.issuer', 'letsencrypt-production'),
        kind: 'ClusterIssuer',
      },
      commonName: ingress.gateway.https.dnsNames[0],
      dnsNames: ingress.gateway.https.dnsNames,
    },
  },
  contains(list, value):: std.foldl(function(a, b) (a || (b == value)), list, false),

  pruneList(list):: std.foldl(function(a, b) if b == null then a else a + [b], list, []),

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


}

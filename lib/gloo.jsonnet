local certmanager = import 'certmanager.jsonnet';
local expand = import 'expand.jsonnet';
local global = import 'global.jsonnet';
local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';
local linkerd = import 'linkerd.jsonnet';
local pom = import 'pom.jsonnet';
local tracing = import 'tracing.jsonnet';
local init = import 'init.jsonnet';

local AwsTcpLoadBalancer(config) = {  // XXX AWS dependency
  'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
  'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'tcp',
  'service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled': 'true',
  'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
};

local ExternalDnsHosts(hosts) = {
  'external-dns.alpha.kubernetes.io/alias': 'true',
  'external-dns.alpha.kubernetes.io/hostname': std.join(',', hosts),
};

{

  withDefault(obj, field, default)::
    if obj == null || std.objectHas(obj, field)
    then obj
    else obj { [field]: default },

  // add a default name to an object if it does not have one
  withName(obj, default):: $.withDefault(obj, 'name', default),

  // add a default namespace to an object if it does not have one
  withNamespace(obj, default):: $.withDefault(obj, 'namespace', default),

  // add namespace field to each object under a map if it does not already have one
  addNamespace(map, ns):: std.mapWithKey(function(n, v) $.withNamespace(v, ns), map),

  // add a name field to each entry of a map, where the name is the key
  addName(map):: std.mapWithKey(function(n, v) $.withName(v, n), map),

  vsForNamespacedPackage(name, pkg, package):: (

    // add virtual service name and namespace as key/value pairs in each virtual service
    local taggedVsList(vsmap) = $.addName($.addNamespace(vsmap, name));

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
        name: $.certificateSecretName(vs.name, vs.namespace),
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
    local vs = $.withNamespace($.withName(vsin, defaultName), defaultNamespace),
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
    local gloo = $.withNamespace(config.pkgs.gloo, 'gloo-system');
    local gws = lib.values(std.mapWithKey(function(n, v) $.withName(v, n), gloo.gateways));
    [$.gateway($.withNamespace(gw, gloo.namespace), vss) for gw in gws]
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
              clientName: '%REQ(x-tidepool-client-name)%',
              userAgent: '%REQ(user-agent)%',
              referer: '%REQ(referer)%',
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
    local result = std.map(tovs, vsarray);
    std.filter(function(x) std.length(x.spec.virtualHost.domains) > 0, result)
  ),

  certificatesForPackage(config, pkgname, namespace):: (
    local vsarray = $.vsForNamespacedPackage(namespace, pkgname, config.namespaces[namespace][pkgname]);
    lib.pruneList(std.map(function(v) $.certificate(config, v, pkgname, namespace), vsarray))
  ),

  certificateSecretName(base, namespace):: namespace + '-' + base + '-certificate',

  certificate(config, vsin, defaultName, defaultNamespace):: (
    local vs = $.withNamespace($.withName(vsin, defaultName), defaultNamespace);
    if global.isEnabled(config, 'certmanager')
       && $.isHttps(vs)
       && std.length(vs.dnsNames) > 0
    then certmanager.certificate(config, $.certificateSecretName(vs.name, vs.namespace), vs.namespace, vs.dnsNames)
    else {}
  ),

  baseGatewayProxy(config, me, name):: {
    extraInitContainersHelper: std.manifestJsonEx( [ init.sysctl ], "  " ),
    kind: {
      deployment: {
        replicas: lib.getElse(me, 'proxies.' + name + '.replicas', 2),
      },
    },
    configMap: {
      data: null,
    },
    podTemplate: {
      disableNetBind: false,
      floatingUserId: false,
      probes: true,
      image: {
        repository: if me.pkg == 'gloo' then 'gloo-envoy-wrapper' else 'gloo-ee-envoy-wrapper',
        tag: lib.getElse(me, 'gloo.version', lib.getElse(me, 'version', '1.3.15')),
      },
      httpPort: 8080,
      httpsPort: 8443,
      runAsUser: 10101,
      extraAnnotations: linkerd.annotations(config) + {
        'config.linkerd.io/skip-inbound-ports': 8081,
      },
      resources: {
        limits: {
          memory: '200Mi',
        },
      },
    },
    service: {
      httpPort: 80,
      httpsPort: 443,
    },
    readConfig: true,
    gatewaySettings: {
      disableGeneratedGateways: true,
    },
    tracing: tracing.envoy(config),
  },

  globalValues(config, me, version):: {
    global: {
      glooStats: {
        enabled: true,
      },
      glooRbac: {
        create: true,
      },
      image: {
        pullPolicy: 'IfNotPresent',
        registry: 'quay.io/solo-io',
        tag: version,
      },
    },
    settings: {
      create: false,
      linkerd: true,
    },
  },

  glooValues(config, me, version):: {
    gloo: {
      deployment: {
        resources: {
          requests: {
            cpu: '500m',
            memory: '256Mi',
          },
          limits: {
            memory: '256Mi',
          },
        },
      },
    },
    namespace: {
      create: false,
    },
    discovery: {
      enabled: true,
      fdsMode: 'WHITELIST',
      deployment: {
        resources: {
          limits: {
            memory: '200Mi',
          },
        },
      },
    },
    gateway: {
      deployment: {
        image: {
          repository: 'gateway',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: {
          enabled: true,
        },
      },
      enabled: true,
      proxyServiceAccount: {},
      readGatewaysFromAllNamespaces: true,
      upgrade: false,
      validation: {
        enabled: lib.isEnabledAt(me, 'validation'),
        failurePolicy: 'Ignore',
        secretName: 'gateway-validation-certs',
        alwaysAcceptResources: true,
      },
    },
    gatewayProxies+: {
      pomeriumGatewayProxy: $.baseGatewayProxy(config, me, 'pomeriumGatewayProxy') {
        service+: {
          type: 'LoadBalancer',
          extraAnnotations+:
            AwsTcpLoadBalancer(config) +
            ExternalDnsHosts($.dnsNames(expand.expand(config), { type: 'pomerium' }) + pom.dnsNames(expand.expand(config))),
        },
      },
      internalGatewayProxy: $.baseGatewayProxy(config, me, 'internalGatewayProxy') {
        service+: {
          type: 'ClusterIP',
        },
      },
      gatewayProxy: $.baseGatewayProxy(config, me, 'gatewayProxy') {
        service+: {
          type: 'LoadBalancer',
          extraAnnotations+:
            AwsTcpLoadBalancer(config) +
            ExternalDnsHosts($.dnsNames(expand.expand(config), { type: 'external' })),
        },
      },
    },
  },

  settings(config, me):: k8s.k('gloo.solo.io/v1', 'Settings') + k8s.metadata('default', me.namespace) {
    metadata+: {
      labels: {
        app: 'gloo',
      },
    },
    spec: {
      extensions: {
        configs: {
          'envoy-rate-limit': {
            customConfig: {
              descriptors: [
                {
                  key: 'Unauthenticated',
                  rateLimit: {
                    requestsPerUnit: 60,
                    unit: 'MINUTE',
                  },
                },
                {
                  key: 'Individual',
                  rateLimit: {
                    requestsPerUnit: 10,
                    unit: 'MINUTE',
                  },
                },
                {
                  key: 'SmallClinic',
                  rateLimit: {
                    requestsPerUnit: 30,
                    unit: 'MINUTE',
                  },
                },
              ],
            },
          },
          extauth: {
            extauthzServerRef: {
              name: 'external-auth',
              namespace: 'gloo-system',
            },
          },
        },
      },
      discovery: {
        fdsMode: 'WHITELIST',
      },
      discoveryNamespace: 'gloo-system',
      gateway: if lib.isEnabledAt(me, 'validation') then {
        readGatewaysFromAllNamespaces: true,
        validation: {
          proxyValidationServerAddr: 'gloo:9988',
          alwaysAccept: true,
        },
      } else null,
      gloo: {
        invalidConfigPolicy: {
          invalidRouteResponseBody: 'Gloo Gateway has invalid configuration. Administrators should run `glooctl check` to find and fix config errors.',
          invalidRouteResponseCode: 404,
        },
        xdsBindAddr: '0.0.0.0:9977',
      },
      kubernetesArtifactSource: {},
      kubernetesConfigSource: {},
      kubernetesSecretSource: {},
      linkerd: global.isEnabled(config, 'linkerd'),
      refreshRate: '60s',
    },
  },
}

local certmanager = import 'certmanager.jsonnet';
local common = import 'common.jsonnet';
local global = import 'global.jsonnet';
local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';
local linkerd = import 'linkerd.jsonnet';
local pom = import 'pomerium.jsonnet';
local tracing = import 'tracing.jsonnet';
local aws = import 'aws.jsonnet';
local dns = import 'external-dns.jsonnet';

// TODO this file needs to be refactored. 
//
// The envoy rate limits should be passed in.

local i = {

  // virtualServicesForPkg provides an array of virtual services of a package
  virtualServicesForPkg(me):: lib.values(lib.getElse(me, 'virtualServices', {})),

  // virtualServicesForNamespace provides an array of virtual services of a namespace
  virtualServicesForNamespace(ns):: std.flattenArrays(std.map($.virtualServicesForPkg, lib.values(ns))),

  // virtualServices provides an array of virtual services of a config
  virtualServices(config):: std.flattenArrays(std.map($.virtualServicesForNamespace, lib.values(config.namespaces))),

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

  // sslConfig takes namespace and dns names from virtual service 
  sslConfig(vs):: if $.isHttps(vs) then {
    sslConfig: {
      secretRef: {
        name: $.certificateSecretName(vs.name, vs.namespace),
        namespace: vs.namespace,
      },
      sniDomains: lib.getElse(vs, 'dnsNames', []),
      parameters: {
        minimumProtocolVersion: "TLSv1_2",
      },
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

  virtualHostOptions(vs):: 
    lib.getElse(vs, 'virtualHostOptions', {})
    + (if lib.isEnabledAt(vs, 'hsts') then $.staticVirtualHostOptions.hsts else {}),

  virtualHost(vs):: {
    domains: $.domains(vs),
    routes: $.routes(vs),
    options: $.virtualHostOptions(vs),
  },

  virtualService(vs):: k8s.k('gateway.solo.io/v1', 'VirtualService') {
    metadata+: {
      name: lib.kebabCase(lib.require(vs, 'name')),
      namespace: vs.namespace,
      labels: vs.labels,
    },
    spec: $.sslConfig(vs) + {
      displayName: lib.kebabCase(vs.name),
      virtualHost: $.virtualHost(vs),
    },
  },

  dnsNames(config, selector={ type: 'external' }):: (
    local vss = $.virtualServices(config);
    local externalVss = $.virtualServicesForSelector(vss, selector);
    std.uniq(std.sort(std.flattenArrays(std.map(function(vs) lib.getElse(vs, 'dnsNames', []), externalVss))))
  ),

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

  gateway(gw):: k8s.k('gateway.solo.io/v1', 'Gateway') + k8s.metadata(gw.name, gw.namespace) {
    metadata+: {
      annotations: {
        origin: 'default',
      },
    },
    spec+: {
      httpGateway+: {
        virtualServiceSelector: gw.selector,
        virtualServiceNamespaces: ['*'],
        options:
          (if lib.getElse(gw, 'options.healthCheck', false) then i.healthCheckOption else {})
          + (if lib.getElse(gw, 'options.tracing', false) then i.httpConnectionManagerOption else {}),
      },
      options: lib.getElse(gw, 'accessLogging', {}),
      bindAddress: '::',
      bindPort: i.bindPort(gw.selector.protocol),
      proxyNames: gw.proxies,
      useProxyProto: lib.getElse(gw, 'options.proxyProtocol', false),
      ssl: lib.getElse(gw, 'options.ssl', false),
    },
  },

  certificateSecretName(base, namespace):: namespace + '-' + base + '-certificate',

  certificate(me):: function(vs) (
    if i.isHttps(vs) && std.length(vs.dnsNames) > 0
    then certmanager.certificate(me, vs.dnsNames, i.certificateSecretName(vs.name, vs.namespace))
    else {}
  ),

  baseGatewayProxy(me, name):: {
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
        tag: lib.require(me, 'gloo.version'),
      },
      httpPort: 8080,
      httpsPort: 8443,
      runAsUser: 10101,
      extraAnnotations: linkerd.annotations(me, true, skipInboundPorts=8081),
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
    tracing: tracing.envoy(me.config),
  },

  gatewayValues(me):: {
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

  gatewayProxyValues(me):: {
    pomeriumGatewayProxy: $.baseGatewayProxy(me, 'pomeriumGatewayProxy') {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+:
          aws.tcpLoadBalancer(me.config) +
          dns.externalDnsHosts($.dnsNames(me.config, { type: 'pomerium' }) + pom.dnsNames(me.config)),
      },
    },
    internalGatewayProxy: $.baseGatewayProxy(me, 'internalGatewayProxy') {
      service+: {
        type: 'ClusterIP',
      },
    },
    gatewayProxy: $.baseGatewayProxy(me, 'gatewayProxy') {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+:
          aws.tcpLoadBalancer(me.config) +
          dns.externalDnsHosts($.dnsNames(me.config, { type: 'external' })),
      },
    },
  },

  discoveryValues(me):: {
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

  envoyRateLimits:: {
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
    },
  },
};

{

  virtualServicesForPackage(me):: (
    local result = std.map(i.virtualService, lib.values(lib.getElse(me, 'virtualServices', {})));
    std.filter(function(x) std.length(x.spec.virtualHost.domains) > 0, result)
  ),

  certificatesForPackage(me):: (
    if global.isEnabled(me.config, 'certmanager') || global.isEnabled(me.config, 'certmanager15')
    then std.map(i.certificate(me), lib.values(lib.getElse(me, 'virtualServices', {})))
    else []
  ),

  gateways(me, namespace='gloo-system'):: [i.gateway(gw { namespace: namespace }) for gw in lib.values(lib.getElse(me, 'gateways', {}))],

  // dependent on gloo version
  // selects external auth and rate limiting
  globalValues(me):: {
    global+: {
      glooStats+: {
        enabled: true,
      },
      glooRbac+: {
        create: true,
      },
      image: {
        pullPolicy: 'IfNotPresent',
        registry: 'quay.io/solo-io',
        tag: me.gloo.version,
      },
      extensions+: {
        extAuth+: {
          enabled: lib.isEnabledAt(me, 'extAuth'),
        },
      },
    },
    rateLimit+: {
      enabled: lib.isEnabledAt(me, 'rateLimit'),
    },
  },

  glooValues(me):: {
    gloo+: {
      deployment+: {
        resources+: {
          requests+: {
            cpu: '500m',
            memory: '256Mi',
          },
          limits+: {
            memory: '256Mi',
          },
        },
      },
    },
    namespace+: {
      create: false,
    },
    discovery+: i.discoveryValues(me),
    gateway+: i.gatewayValues(me),
    gatewayProxies+: i.gatewayProxyValues(me),
    settings+: {
      create: me.pkg == 'gloo',  // false for gloo-ee
    },
  },

  upstream(me, name=me.pkg):: k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata(name, me.namespace),

  kubeupstream(me, port=8080, name=me.pkg):: $.upstream(me, name) {
    spec+: {
      kube+: {
        serviceName: name,
        serviceNamespace: me.namespace,
        servicePort: port,
      },
    },
  },

  simpleRoutetable(me, labels, name=me.pkg, prefix='/v2/%s' % me.pkg, noauth=false):: $.routetable(me, labels, name) {
    spec+: {
      routes: [{
        matchers: [{
          methods: ["GET", "DELETE", "PATCH", "POST", "PUT"],
          prefix: prefix,
        }],
        options: {
          jwt: {
            disable: noauth
          },
        },
        routeAction: {
          single: {
            upstream: {
              name: me.pkg,
              namespace: me.namespace,
            },
          },
        },
      }],
    },
  },

  routetable(me, labels, name=me.pkg):: k8s.k('gateway.solo.io/v1', 'RouteTable') + k8s.metadata(name, me.namespace) {
    metadata+: {
      labels+: labels {
        namespace: me.namespace,
      },
    },
  },

  virtualService(me, name=me.pkg):: k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata(name, me.namespace) {
    spec+: {
      displayName: name,
    },
  },
}

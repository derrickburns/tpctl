local lib = import '../lib/lib.jsonnet';

{
  // select all ingress sub-objects across the entire configuration
  ingresses(config):: (
    local envs = lib.environments(config);
    local pkgs = lib.packages(config);
    std.prune(std.mapWithKey(function(n, v) lib.getElse(v, 'ingress', null), envs + pkgs))
  ),

  // filter ingresses by name
  ingressesForGateway(ingresses, gateway)::
    std.prune(
      std.mapWithKey(
        function(n, v)
          if lib.isTrue(v, 'service.' + gateway + '.enabled') then v else null, 
          ingresses
      )
    ),

  gatewayName(protocol, isInternal):: if isInternal then protocol + '-internal' else protocol,

  // We are awaiting a change in Gloo to allow Gateways to select virtual services 
  // across namespaces using labels. 
  //
  // Until then, we select virtual services for a gateway using the convention that
  // the name of the virtual service is the name of the gateway that includes it.
  virtualServices(config, protocol, isInternal):: (
    local ingresses = $.ingresses(config);
    local gateway = $.gatewayName(procotol, isInternal);
    lib.values(
      std.mapWithKey(
        function(n, v) { name: gateway, namespace: n }, $.ingressesForGateway(ingresses, gateway)
      )
    )
  ),


  proxyName(isInternal):: if isInternal then 'internal-gateway-proxy' else 'gateway-proxy',

  bindPort(protocol)::
    if protocol == 'http'
    then 8080
    else 8433,

  gateway(config, protocol, isInternal):: {
    apiVersion: 'gateway.solo.io/v1',
    kind: 'Gateway',
    metadata: {
      annotations: {
        origin: 'default',
      },
      name: $.gatewayName(protocol, isInternal),
      namespace: lib.getElse(config, 'pkgs.gloo.namespace', 'gloo-system'),
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
    },
  },
}

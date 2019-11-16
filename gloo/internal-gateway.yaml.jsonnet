local lib = import '../lib/lib.jsonnet';

local gateway(config) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'Gateway',
  metadata: {
    annotations: {
      origin: 'default',
    },
    name: 'internal-gateway-proxy',
    namespace: lib.getElse(config, 'pkgs.gloo.namespace', 'gloo-system'),
  },
  spec: {
    httpGateway: {
      virtualServices: lib.virtualServices(config, "internal"),
      settings: {
        httpConnectionManagerSettings: {
          tracing: {
            verbose: true,
            requestHeadersForTags: [ "path", "origin" ]
          }
        },
        healthCheck: {
          path: '/status',
        },
      },
    },
    settings: {
      accessLoggingService: {
        accessLog: [
          {
            fileSink: {
              jsonFormat: {
                authority: '%REQ(:authority)%',
                authorization: '%REQ(authorization)%',
                content: '%REQ(content-type)%',
                duration: '%DURATION%',
                forwardedFor: "%REQ(X-FORWARDED-FOR)%",
                method: '%REQ(:method)%',
                path: '%REQ(:path)%',
                remoteAddress: "%DOWNSTREAM_REMOTE_ADDRESS_WITHOUT_PORT%",
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
    bindPort: 8080,
    proxyNames: [
      'internal-gateway-proxy',
    ],
    useProxyProto: false,
  },
};

function(config) gateway(config)

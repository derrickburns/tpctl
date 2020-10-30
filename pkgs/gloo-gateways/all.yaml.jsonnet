local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local accessLogging = {
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
          b3TraceId: '%REQ(x-b3-traceid)%',
          upstream: '%UPSTREAM_CLUSTER%',
          upstreamHost: '%UPSTREAM_HOST%',
          clientName: '%REQ(x-tidepool-client-name)%',
          userAgent: '%REQ(user-agent)%',
          referer: '%REQ(referer)%',
        },
        path: '/dev/stdout',
      },
    },
  ],
};

local gateways = {
  'gateway-proxy'+: {
    enabled: true,
    options: {
      accessLoggingService: accessLogging,
    },
    flags+: {
      healthCheck: true,
      proxyProtocol: true,
      tracing: {
        enabled: true,
      },
    },
    proxy: 'gateway-proxy',
    selector: {
      protocol: 'http',
      type: 'external',
    },
  },
  'gateway-proxy-ssl'+: {
    enabled: true,
    options: {
      accessLoggingService: accessLogging,
    },
    flags+: {
      healthCheck: true,
      proxyProtocol: true,
      ssl: true,
      tracing: {
        enabled: true,
        // Add more settings
        // randomSamplePercentage: 89.0,
      },
      buffer: true,
    },
    proxy: 'gateway-proxy',
    selector: {
      protocol: 'https',
      type: 'external',
    },
  },
  'internal-gateway-proxy'+: {
    enabled: true,
    options: {
      accessLoggingService: accessLogging,
    },
    flags+: {
      trustForwardedHeaders: {
        hops: 1,
      },
      tracing: {
        enabled: true,
      },
    },
    proxy: 'internal-gateway-proxy',
    selector: {
      protocol: 'http',
      type: 'internal',
    },
  },
  'internal-gateway-proxy-ssl'+: {
    enabled: true,
    options: {
      accessLoggingService: accessLogging,
    },
    flags+: {
      ssl: true,
      tracing: {
        enabled: true,
      },
    },
    proxy: 'internal-gateway-proxy',
    selector: {
      protocol: 'https',
      type: 'internal',
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    gloo.gateway(gw { namespace: namespace })
    for gw in lib.asArrayWithField(lib.merge(gateways, lib.getElse(me, 'gateways', {})), 'name')
  ]
)

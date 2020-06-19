local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local accessLogging = {
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
};

local gateways = {
  'gateway-proxy'+: {
    enabled: true,
    accessLogging: accessLogging,
    options+: {
      healthCheck: true,
      proxyProtocol: true,
      tracing: true,
    },
    proxy: 'gateway-proxy',
    selector: {
      protocol: 'http',
      type: 'external',
    },
  },
  'gateway-proxy-ssl'+: {
    enabled: true,
    accessLogging: accessLogging,
    options+: {
      healthCheck: true,
      proxyProtocol: true,
      ssl: true,
      tracing: true,
    },
    proxy: 'gateway-proxy',
    selector: {
      protocol: 'https',
      type: 'external',
    },
  },
  'internal-gateway-proxy'+: {
    enabled: true,
    accessLogging: accessLogging,
    options+: {
      tracing: true,
    },
    proxy: 'internal-gateway-proxy',
    selector: {
      protocol: 'http',
      type: 'internal',
    },
  },
  'internal-gateway-proxy-ssl'+: {
    enabled: true,
    accessLogging: accessLogging,
    options+: {
      ssl: true,
      tracing: true,
    },
    proxy: 'internal-gateway-proxy',
    selector: {
      protocol: 'https',
      type: 'internal',
    },
  },
};

local defaultPort(protocol) = if protocol == 'http' then 80 else 443;

local bindPort(protocol) = 8000 + defaultPort(protocol);

local httpConnectionManagerOption = {
  httpConnectionManagerSettings: {
    useRemoteAddress: true,
    tracing: {
      verbose: true,
      requestHeadersForTags: ['path', 'origin'],
    },
  },
};

local healthCheckOption = {
  healthCheck: {
    path: '/status',
  },
};

local gateway(gw) = k8s.k('gateway.solo.io/v1', 'Gateway') + k8s.metadata(gw.name, gw.namespace) {
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
        (if lib.getElse(gw, 'options.healthCheck', false) then healthCheckOption else {})
        + (if lib.getElse(gw, 'options.tracing', false) then httpConnectionManagerOption else {}),
    },
    options: lib.getElse(gw, 'accessLogging', {}),
    bindAddress: '::',
    bindPort: bindPort(gw.selector.protocol),
    proxyNames: [gw.proxy],
    useProxyProto: lib.getElse(gw, 'options.proxyProtocol', false),
    ssl: lib.getElse(gw, 'options.ssl', false),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    gateway(gw { namespace: namespace })
      for gw in lib.asArrayWithField(lib.merge(gateways, lib.getElse(me, 'gateways', {})), 'name')
  ]
)

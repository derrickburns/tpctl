local gateway(config) = {
  apiVersion: "gateway.solo.io.v2/v2",
  kind: "Gateway",
  metadata: {
    annotations: {
      origin: "default"
    },
    name: "gateway-proxy-v2",
    namespace: config.pkgs.gloo.namespace,
  },
  spec: {
    bindAddress: "::",
    bindPort: 8080,
    httpGateway: {},
    proxyNames: [
      "gateway-proxy-v2"
    ],
    useProxyProto: false
  }
};

function(config) gateway(config)

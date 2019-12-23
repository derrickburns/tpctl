local lib = import "../../lib/lib.jsonnet";

local jaeger(config) = {
  apiVersion: 'jaegertracing.io/v1',
  kind: 'Jaeger',
  metadata: {
    name: 'jaeger',
    namespace: 'tracing',
  },
  spec: {
    ingress: {
      enabled: false
    },
  },
};

function(config, prev) 
  if lib.getElse(config, 'pkgs.tracing.enabled.off', false)
  then jaeger(config)
  else {}

local jaeger(config) = {
  apiVersion: 'jaegertracing.io/v1',
  kind: 'Jaeger',
  metadata: {
    name: lib.getElse(config, 'pkgs.jaeger.name', 'simplest'),
    namespace: lib.getElse(config, 'pkgs.jaeger.namespace', 'default'),
  },
};

function(config, prev) 
  if lib.getElse(config, 'pkgs.jaeger.enabled', false)
  then jaeger(config)
  else {}

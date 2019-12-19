local lib = import "../../lib/lib.jsonnet";

{
  address(config):: 'oc-collector.tracing.svc.cluster.local:55678',
    
  tracingAnnotation(config)::
    if lib.getElse(config, 'pkgs.tracing.enabled', false)
    then {
      'config.linkerd.io/trace-collector': $.address(config),
    } else {},

  envoy(config):: if lib.getElse(config, 'pkgs.tracing.enabled', false) then {
    provider: {
      name: 'envoy.zipkin',
      typed_config: {
        '@type': 'type.googleapis.com/envoy.config.trace.v2.ZipkinConfig',
        collector_cluster: 'zipkin',
        collector_endpoint: '/api/v1/spans',
      },
    },
    cluster: [
      {
        name: 'zipkin',
        connect_timeout: '1s',
        type: 'STRICT_DNS',
        load_assignment: {
          cluster_name: 'zipkin',
          endpoints: [
            {
              lb_endpoints: [
                {
                  endpoint: {
                    address: {
                      socket_address: {
                        address: '%s-collector.%s' % [
                          lib.getElse(config, 'pkgs.tracing.name', 'jaeger'),
                          lib.getElse(config, 'pkgs.tracing.namespace', 'tracing')],
                        port_value: lib.getElse(config, 'pkgs.jaeger.port', 9411),
                      },
                    },
                  },
                },
              ],
            },
          ],
        },
      },
    ],
  } else null,
}


local lib = import '../../lib/lib.jsonnet';

{
  address(config):: 'oc-collector.%s:55678' % config.pkgs.tracing.namespace,

  envoy(config):: if lib.getElse(config, 'pkgs.tracing.enabled', false) then {
    provider: {
      name: 'envoy.tracers.opencensus',
      typed_config: {
        '@type': 'type.googleapis.com/envoy.config.trace.v2.OpenCensusConfig',
        ocagent_exporter_enabled: true,
        ocagent_address: 'dns:%s' % $.address(config),
        incoming_trace_context: ['B3'],
        outgoing_trace_context: ['B3'],
      },
    },
  } else null,
}

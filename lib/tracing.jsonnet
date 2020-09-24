local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';

{
  address(config):: 'otel-agent.%s:55678' % lib.getElse(global.package(config, 'opentelemetry'), 'namespace', null),  // XXX

  collector(me):: 'http://jaeger-collector.%s:14268/api/traces' % lib.getElse(global.package(me.config, 'jaeger'), 'namespace', null),

  agent(me):: 'http://jaeger-agent.%s' % lib.getElse(global.package(me.config, 'jaeger'), 'namespace', null),

  envoy(me):: if lib.isEnabledAt(me, 'tracing') then {
    provider: {
      name: 'envoy.tracers.opencensus',
      typed_config: {
        '@type': 'type.googleapis.com/envoy.config.trace.v2.OpenCensusConfig',
        ocagent_exporter_enabled: true,
        ocagent_address: 'dns:%s' % $.address(me.config),
        incoming_trace_context: ['B3'],
        outgoing_trace_context: ['B3'],
      },
    },
  } else null,

  tracingAnnotations(config):: if global.isEnabled(config, 'opentelemetry') then {
    'config.linkerd.io/trace-collector': 'otel-agent.%s:55678' % lib.getElse(global.package(config, 'opentelemetry'), 'namespace', null),
  } else {},
}

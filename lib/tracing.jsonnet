local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';

{
  address(config):: 'oc-collector.%s:55678' % lib.getElse(global.package(config, 'oc-collector'), 'namespace', null),  // XXX

  collector(me):: 'http://jaeger-collector.%s:14268/api/traces' %  lib.getElse(global.package(me.config, 'jaeger'), 'namespace',  null),

  agent(me):: 'http://jaeger-agent.%s' %  lib.getElse(global.package(me.config, 'jaeger'), 'namespace',  null),

  envoy(config):: if global.isEnabled(config, 'oc-collector') then {
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

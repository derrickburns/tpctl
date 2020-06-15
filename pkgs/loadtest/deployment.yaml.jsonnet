local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/loadtest:latest',
    env: if global.isEnabled(me.config, 'statsd-exporter') then [
      k8s.envVar('K6_STATSD_ADDR', 'statsd-exporter.monitoring:9125'),
    ] else [],
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

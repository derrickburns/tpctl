local common = import '../../lib/common.jsonnet';
local grafana = import '../../lib/grafana.jsonnet';
local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);

  std.prune(
    [grafana.dashboard(me, '%s-overview' % me.pkg, importstr 'dashboards/overview.json')] +
    (if lib.isEnabledAt(me, 'compact') then [grafana.dashboard(me, '%s-compact' % me.pkg, importstr 'dashboards/compact.json', true)] else []) +
    (if lib.isEnabledAt(me, 'sidecar') then [grafana.dashboard(me, '%s-sidecar' % me.pkg, importstr 'dashboards/sidecar.json', true)] else []) +
    (if lib.isEnabledAt(me, 'store') then [grafana.dashboard(me, '%s-store' % me.pkg, importstr 'dashboards/store.json', true)] else []) +
    (if lib.isEnabledAt(me, 'query') then [grafana.dashboard(me, '%s-query' % me.pkg, importstr 'dashboards/query.json', true)] else [])
  )
)

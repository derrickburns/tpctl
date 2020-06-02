local global = import 'global.jsonnet';
local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  dashboard(me, dashboardName, dashboardConfig):: k8s.configmap(me, '%s-dashboard' % dashboardName) {

    metadata+: {
      labels: {
        grafana_dashboard: '%s-dashboard' % dashboardName,
      },
    },
    data: {
      ['%s.json' % dashboardName]: std.manifestJsonEx(
        dashboardConfig, '  '
      ),
    },
  },
}

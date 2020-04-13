local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local configmap(me) = k8s.configmap(me) {
  data: {
    'dashboardproviders.yaml': std.manifestJsonEx({
      apiVersion: 1,
      providers: [
        {
          disableDeletion: false,
          editable: true,
          folder: 'gloo',
          name: 'gloo',
          options: {
            path: '/var/lib/grafana/dashboards/gloo',
          },
          orgId: 1,
          type: 'file',
        },
      ],
    }, '  '),
    'datasources.yaml': std.manifestJsonEx({
      apiVersion: 1,
      datasources: [
        {
          access: 'proxy',
          isDefault: true,
          name: 'gloo',
          type: 'prometheus',
          url: 'http://glooe-prometheus-server:80', // XXX remove hardcoding
        },
      ],
    }, '  '),
    'grafana.ini': std.manifestIni({
      sections: {
        analytics: { check_for_updates: 'true' },
        grafana_net: { url: 'https://grafana.net' },
        log: { mode: 'console' },
        paths: {
          data: '/var/lib/grafana/data',
          logs: '/var/log/grafana',
          plugins: '/var/lib/grafana/plugins',
          provisioning: '/etc/grafana/provisioning',
        },
      },
    }),
  },
};

function(config, prev, namespace, pkg) configmap(lib.package(config, namespace, pkg))

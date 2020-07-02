local common = import '../../../lib/common.jsonnet';
local global = import '../../../lib/global.jsonnet';
local grafana = import '../../../lib/grafana.jsonnet';

local dashboardConfig = {
  annotations: {
    list: [
      {
        builtIn: 1,
        datasource: '-- Grafana --',
        enable: true,
        hide: true,
        iconColor: 'rgba(0, 211, 255, 1)',
        name: 'Annotations & Alerts',
        type: 'dashboard',
      },
    ],
  },
  description: 'Shared Cluster',
  editable: false,
  gnetId: null,
  graphTooltip: 0,
  links: [],
  panels: [
    {
      collapsed: false,
      datasource: '$datasource',
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 0,
      },
      id: 25,
      panels: [],
      title: 'Tidepool',
      type: 'row',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 0,
        y: 1,
      },
      headings: false,
      id: 38,
      limit: 10,
      query: 'Loadtest / K6',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'QA',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 8,
        y: 1,
      },
      headings: false,
      id: 39,
      limit: 10,
      query: 'Kubernetes / Jobs',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Cronjobs / Jobs',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 3,
        w: 8,
        x: 0,
        y: 5,
      },
      headings: false,
      id: 34,
      limit: 10,
      query: 'Alerts',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Alerts',
      type: 'dashlist',
    },
    {
      collapsed: false,
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 8,
      },
      id: 42,
      panels: [],
      title: 'AWS',
      type: 'row',
    },
    {
      datasource: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 8,
        x: 0,
        y: 9,
      },
      headings: false,
      id: 44,
      limit: 10,
      query: 'AWS / SES',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'SES',
      type: 'dashlist',
    },
    {
      collapsed: false,
      datasource: '$datasource',
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 12,
      },
      id: 27,
      panels: [],
      title: 'Other Services',
      type: 'row',
    },
    {
      content: '<h3 style="text-align: center;">\nKubernetes Resources\n</h3>\n<hr/>\n\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 13,
      },
      id: 6,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 9,
        w: 8,
        x: 0,
        y: 15,
      },
      headings: false,
      id: 2,
      limit: 10,
      query: 'cluster',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Cluster',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 9,
        w: 8,
        x: 8,
        y: 15,
      },
      headings: false,
      id: 13,
      limit: 10,
      query: 'Node',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Node',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 9,
        w: 8,
        x: 16,
        y: 15,
      },
      headings: false,
      id: 17,
      limit: 10,
      query: 'Pod',
      recent: false,
      search: true,
      starred: false,
      tags: [
        'kubernetes-mixin',
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Pod',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 0,
        y: 24,
      },
      headings: false,
      id: 4,
      limit: 10,
      query: 'Autoscaler',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Autoscaler',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 8,
        y: 24,
      },
      headings: false,
      id: 32,
      limit: 10,
      query: 'Kubernetes / Deployment / All',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Deployments',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 16,
        y: 24,
      },
      headings: false,
      id: 35,
      limit: 10,
      query: 'Statefulsets',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'StatefulSets',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 0,
        y: 28,
      },
      headings: false,
      id: 36,
      limit: 10,
      query: 'Persistent Volumes',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Persistent Volumes',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 4,
        w: 8,
        x: 8,
        y: 28,
      },
      headings: false,
      id: 40,
      limit: 10,
      query: 'Kubernetes / Jobs',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Cronjobs / Jobs',
      type: 'dashlist',
    },
    {
      content: '<hr/>\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 32,
      },
      id: 19,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      content: '<h3 style="text-align: center;">\nAPI Gateway\n</h3>\n<hr/>\n\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 12,
        x: 0,
        y: 34,
      },
      id: 8,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      content: '<h3 style="text-align: center;">\nLinkerd\n</h3>\n<hr/>\n\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 12,
        x: 12,
        y: 34,
      },
      id: 9,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 7,
        w: 6,
        x: 0,
        y: 36,
      },
      headings: false,
      id: 3,
      limit: 10,
      query: 'envoy',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Envoy',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 7,
        w: 6,
        x: 6,
        y: 36,
      },
      headings: false,
      id: 11,
      limit: 10,
      query: 'gloo',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Gloo',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 7,
        w: 12,
        x: 12,
        y: 36,
      },
      headings: false,
      id: 5,
      limit: 10,
      query: 'linkerd',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Linkerd',
      type: 'dashlist',
    },
    {
      content: '<h3 style="text-align: center;">\nCI/CD\n</h3>\n<hr/>\n\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 43,
      },
      id: 12,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 0,
        y: 45,
      },
      headings: false,
      id: 10,
      limit: 10,
      query: 'Flux',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Flux',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 8,
        y: 45,
      },
      headings: false,
      id: 14,
      limit: 10,
      query: 'Helm Operator',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Helm Operator',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 16,
        y: 45,
      },
      headings: false,
      id: 23,
      limit: 10,
      query: '',
      recent: false,
      search: true,
      starred: false,
      tags: [
        'pomerium',
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Pomerium',
      type: 'dashlist',
    },
    {
      content: '<h3 style="text-align: center;">\nUtils\n</h3>\n<hr/>\n\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 50,
      },
      id: 15,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 0,
        y: 52,
      },
      headings: false,
      id: 16,
      limit: 10,
      query: 'External DNS',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'External DNS',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 8,
        y: 52,
      },
      headings: false,
      id: 18,
      limit: 10,
      query: 'Cert Manager',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Cert Manager',
      type: 'dashlist',
    },
    {
      content: '<h3 style="text-align: center;">\nMonitoring\n</h3>\n<hr/>\n\n',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 57,
      },
      id: 20,
      mode: 'html',
      timeFrom: null,
      timeShift: null,
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 0,
        y: 59,
      },
      headings: false,
      id: 21,
      limit: 10,
      query: 'Grafana',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Grafana',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 8,
        y: 59,
      },
      headings: false,
      id: 22,
      limit: 10,
      query: 'Prometheus',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Prometheus',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      folderId: null,
      gridPos: {
        h: 5,
        w: 8,
        x: 16,
        y: 59,
      },
      headings: false,
      id: 30,
      limit: 10,
      query: 'Alertmanager',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Alertmanager',
      type: 'dashlist',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 10,
        w: 8,
        x: 0,
        y: 64,
      },
      headings: false,
      id: 45,
      limit: 10,
      query: 'Exporter',
      recent: false,
      search: true,
      starred: false,
      tags: [],
      timeFrom: null,
      timeShift: null,
      title: 'Exporters',
      type: 'dashlist',
    },
  ],
  schemaVersion: 25,
  style: 'dark',
  tags: [],
  templating: {
    list: [],
  },
  time: {
    from: 'now-6h',
    to: 'now',
  },
  timepicker: {
    refresh_intervals: [
      '10s',
      '30s',
      '1m',
      '5m',
      '15m',
      '30m',
      '1h',
      '2h',
      '1d',
    ],
  },
  timezone: '',
  title: 'Home',
  uid: 'HRN3fEzGk',
  version: 3,
};

local configmap(me) = grafana.dashboard(me, 'home', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name == 'shared'
  then [
    configmap(me),
  ]
  else {}
)

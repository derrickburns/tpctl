local common = import '../../lib/common.jsonnet';
local grafana = import '../../lib/grafana.jsonnet';
local lib = import '../../lib/lib.jsonnet';

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
  editable: false,
  gnetId: null,
  graphTooltip: 0,
  iteration: 1603736194863,
  links: [],
  panels: [
    {
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 0,
      },
      id: 16,
      title: 'Jira',
      type: 'row',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              from: '',
              id: 0,
              text: 'True',
              to: '',
              type: 1,
              value: '1',
            },
            {
              from: '',
              id: 1,
              text: 'False',
              to: '',
              type: 1,
              value: '0',
            },
          ],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: null,
              },
              {
                color: 'green',
                value: 1,
              },
            ],
          },
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 5,
        x: 0,
        y: 1,
      },
      id: 24,
      options: {
        colorMode: 'background',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'sum(argo_workflows_atlassian_backup_status{backup_name="jira"})',
          instant: false,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Last Jira Backup Successful',
      type: 'stat',
    },
    {
      collapsed: false,
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 6,
      },
      id: 4,
      panels: [],
      title: 'Confluence',
      type: 'row',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              from: '',
              id: 0,
              text: 'True',
              to: '',
              type: 1,
              value: '1',
            },
            {
              from: '',
              id: 1,
              text: 'False',
              to: '',
              type: 1,
              value: '0',
            },
          ],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: null,
              },
              {
                color: 'green',
                value: 1,
              },
            ],
          },
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 5,
        x: 0,
        y: 7,
      },
      id: 25,
      options: {
        colorMode: 'background',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'sum(argo_workflows_atlassian_backup_status{backup_name="confluence"})',
          instant: false,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Last Confluence Backup Successful',
      type: 'stat',
    },
    {
      collapsed: false,
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 12,
      },
      id: 22,
      panels: [],
      title: 'X Ray',
      type: 'row',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              from: '',
              id: 0,
              text: 'True',
              to: '',
              type: 1,
              value: '1',
            },
            {
              from: '',
              id: 1,
              text: 'False',
              to: '',
              type: 1,
              value: '0',
            },
          ],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: null,
              },
              {
                color: 'green',
                value: 1,
              },
            ],
          },
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 5,
        x: 0,
        y: 13,
      },
      id: 26,
      options: {
        colorMode: 'background',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'sum(argo_workflows_atlassian_backup_status{backup_name="xray"})',
          instant: false,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Last XRay Backup Successful',
      type: 'stat',
    },
  ],
  schemaVersion: 26,
  style: 'dark',
  tags: [
    'ops',
  ],
  templating: {
    list: [
      {
        current: {
          selected: false,
          text: 'Prometheus',
          value: 'Prometheus',
        },
        hide: 2,
        includeAll: false,
        label: '',
        multi: false,
        name: 'datasource',
        options: [],
        query: 'prometheus',
        refresh: 1,
        regex: '',
        skipUrlSync: false,
        type: 'datasource',
      },
    ],
  },
  time: {
    from: 'now-30d',
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
  title: 'Operations / Backups / Atlassian',
  uid: 'OrKE9XnMz',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'atlassian-backups', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
  ]
)

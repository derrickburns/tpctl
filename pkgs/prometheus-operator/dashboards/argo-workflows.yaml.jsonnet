local common = import '../../../lib/common.jsonnet';
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
  editable: false,
  gnetId: null,
  graphTooltip: 0,
  iteration: 1598653511908,
  links: [],
  panels: [
    {
      cacheTimeout: null,
      datasource: 'Prometheus',
      description: 'Number of Succeeded Jobs',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
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
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 4,
        x: 0,
        y: 0,
      },
      id: 13,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.1.1',
      targets: [
        {
          expr: 'sum(argo_workflows_count{status="Succeeded"}) by (status)',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Jobs Succeeded',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: 'Prometheus',
      description: '',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'blue',
                value: 0,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 4,
        x: 4,
        y: 0,
      },
      id: 7,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.1.1',
      targets: [
        {
          expr: 'sum(argo_workflows_count{status="Running"}) by (status)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Jobs Running',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: 'Prometheus',
      description: '',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'blue',
                value: 0,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 4,
        x: 8,
        y: 0,
      },
      id: 9,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.1.1',
      targets: [
        {
          expr: 'sum(argo_workflows_count{status="Pending"}) by (status)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Jobs Pending',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: 'Prometheus',
      description: 'Number of Succeeded Jobs',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'red',
                value: 1,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 4,
        x: 12,
        y: 0,
      },
      id: 5,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.1.1',
      targets: [
        {
          expr: 'sum(argo_workflows_count{status="Failed"}) by (status)',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Jobs Failed',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: 'Prometheus',
      description: 'Number of Succeeded Jobs',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'red',
                value: 1,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 4,
        x: 16,
        y: 0,
      },
      id: 14,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.1.1',
      targets: [
        {
          expr: 'sum(argo_workflows_count{status="Error"}) by (status)',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Jobs Errored',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: 'Prometheus',
      description: '',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'red',
                value: 1,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 4,
        x: 20,
        y: 0,
      },
      id: 8,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      pluginVersion: '7.1.1',
      targets: [
        {
          expr: 'sum(argo_workflows_count{status="Skipped"}) by (status)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Jobs Skipped',
      type: 'stat',
    },
  ],
  schemaVersion: 26,
  style: 'dark',
  tags: [
    'argo',
    'workflows',
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
        label: null,
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
    from: 'now-2d',
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
  title: 'Argo / Workflows',
  uid: 'uVdF7PHGk',
  version: 3,
};

local configmap(me) = grafana.dashboard(me, 'argo-workflows', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name == 'shared'
  then [
    configmap(me),
  ]
  else {}
)

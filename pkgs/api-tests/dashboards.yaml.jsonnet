local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
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
  iteration: 1601641606416,
  links: [],
  panels: [
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {
            align: null,
            displayMode: 'color-background',
            filterable: false,
          },
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
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Environment',
            },
            properties: [
              {
                id: 'custom.displayMode',
                value: 'auto',
              },
            ],
          },
        ],
      },
      gridPos: {
        h: 7,
        w: 24,
        x: 0,
        y: 0,
      },
      id: 2,
      options: {
        showHeader: true,
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'sum(argo_workflows_api_tests_status) by (env)',
          format: 'table',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'API tests',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              __name__: true,
              endpoint: true,
              instance: true,
              job: true,
              namespace: true,
              pod: true,
              service: true,
            },
            indexByName: {},
            renameByName: {
              Value: 'Passed',
              env: 'Environment',
            },
          },
        },
      ],
      type: 'table',
    },
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      decimals: 0,
      description: '1 == passed\n0 == failed',
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
          ],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'red',
                value: 80,
              },
            ],
          },
        },
        overrides: [],
      },
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 10,
        w: 24,
        x: 0,
        y: 7,
      },
      hiddenSeries: false,
      id: 4,
      legend: {
        alignAsTable: true,
        avg: false,
        current: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      nullPointMode: 'null',
      options: {
        alertThreshold: true,
      },
      percentage: false,
      pluginVersion: '7.2.0',
      pointradius: 0.5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(argo_workflows_api_tests_status) by (env)',
          interval: '',
          legendFormat: '{{ env }}',
          refId: 'A',
        },
      ],
      thresholds: [
        {
          colorMode: 'critical',
          fill: true,
          line: true,
          op: 'lt',
          value: 0.5,
          yaxis: 'left',
        },
      ],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'API tests over time',
      tooltip: {
        shared: true,
        sort: 0,
        value_type: 'individual',
      },
      type: 'graph',
      xaxis: {
        buckets: null,
        mode: 'time',
        name: null,
        show: true,
        values: [],
      },
      yaxes: [
        {
          decimals: 0,
          format: 'short',
          label: null,
          logBase: 1,
          max: '1',
          min: null,
          show: true,
        },
        {
          decimals: null,
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
      ],
      yaxis: {
        align: false,
        alignLevel: null,
      },
    },
  ],
  schemaVersion: 26,
  style: 'dark',
  tags: [],
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
    from: 'now-7d',
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
  title: 'Tidepool / QA / API tests',
  uid: 'GnXedqNMz',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'api-tests', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
  ]
)

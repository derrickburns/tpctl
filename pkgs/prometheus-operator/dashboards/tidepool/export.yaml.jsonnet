local common = import '../../../../lib/common.jsonnet';
local grafana = import '../../../../lib/grafana.jsonnet';
local lib = import '../../../../lib/lib.jsonnet';

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
  iteration: 1597758746977,
  links: [],
  panels: [
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      decimals: 0,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 9,
        w: 24,
        x: 0,
        y: 0,
      },
      hiddenSeries: false,
      id: 2,
      interval: '',
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        hideZero: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 2,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(tidepool_export_status_count{namespace="$env"}[5m])) by (status_code, export_format)',
          interval: '5m',
          legendFormat: '{{ export_format }} - {{ status_code }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Export Statuses [5m]',
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
          '$$hashKey': 'object:464',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:465',
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
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'export',
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
      {
        allValue: null,
        current: {
          selected: false,
          text: 'tidepool-prod',
          value: 'tidepool-prod',
        },
        datasource: '$datasource',
        definition: 'label_values(tidepool_export_status_count, namespace)',
        hide: 0,
        includeAll: false,
        label: 'Environment',
        multi: false,
        name: 'env',
        options: [],
        query: 'label_values(tidepool_export_status_count, namespace)',
        refresh: 1,
        regex: '',
        skipUrlSync: false,
        sort: 0,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
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
  title: 'Tidepool / Services / Export',
  uid: 'HNqFvjVGk',
  version: 2,
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.getElse(me, 'tidepoolMonitoring', true)
  then [
    grafana.dashboard(me, 'tidepool-export', dashboardConfig),
  ]
  else {}
)

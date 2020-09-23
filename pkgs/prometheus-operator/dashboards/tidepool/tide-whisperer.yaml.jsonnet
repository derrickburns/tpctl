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
  id: 392,
  iteration: 1597930495773,
  links: [],
  panels: [
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
      description: 'A counter of slow data checks by Tide whisperer.',
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
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: true,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      nullPointMode: 'null',
      percentage: false,
      pluginVersion: '7.1.1',
      pointradius: 2,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(tidepool_tide_whisperer_slow_data_check_count{namespace="$namespace"}[2m])) by (data_access_type,manufacturer)',
          interval: '',
          legendFormat: '{{ data_access_type }} - {{ manufacturer }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Slow data checks',
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
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
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
  tags: [
    'tide-whisperer',
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
          text: 'qa1',
          value: 'qa1',
        },
        datasource: 'Prometheus',
        definition: 'label_values(tidepool_tide_whisperer_slow_data_check_count, namespace)',
        hide: 0,
        includeAll: false,
        label: 'Namespace',
        multi: false,
        name: 'namespace',
        options: [],
        query: 'label_values(tidepool_tide_whisperer_slow_data_check_count, namespace)',
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
  title: 'Tidepool / Services / Tide Whisperer',
  uid: '879OwNHMk',
  version: 2,
};

local configmap(me) = grafana.dashboard(me, 'tidepool-tide-whisperer', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    grafana.dashboard(me, 'tidepool-tide-whisperer', dashboardConfig),
  ]
)

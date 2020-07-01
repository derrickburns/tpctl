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
  description: 'Dashboard for Amazon CloudWatch exporter API calls: https://github.com/prometheus/cloudwatch_exporter',
  editable: false,
  gnetId: 10925,
  graphTooltip: 0,
  id: 372,
  links: [],
  panels: [
    {
      datasource: '$datasource',
      description: 'Assumption of $10 per 1M calls',
      fieldConfig: {
        defaults: {
          color: {
            mode: 'thresholds',
          },
          custom: {},
          mappings: [],
          max: 1000,
          min: 0,
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
          unit: 'currencyUSD',
        },
        overrides: [],
      },
      gridPos: {
        h: 9,
        w: 9,
        x: 0,
        y: 0,
      },
      id: 8,
      links: [],
      options: {
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'last',
          ],
          fields: '',
          values: false,
        },
        showThresholdLabels: false,
        showThresholdMarkers: true,
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: '(sum(increase(cloudwatch_requests_total[2w])) / 14) * 30 * 10 * 1.3 / 1000000',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Potential monthly bill (projection based on the last 2 weeks with 30% buffer)',
      type: 'gauge',
    },
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
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
        w: 15,
        x: 9,
        y: 0,
      },
      hiddenSeries: false,
      id: 4,
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
      links: [],
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
          expr: 'container_memory_usage_bytes{container_name="prometheus-cloudwatch-exporter"}',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: 'Memory Usage (in MB)',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Memory Usage (MB)',
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
          format: 'bytes',
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
    {
      aliasColors: {},
      bars: false,
      cacheTimeout: null,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 11,
        w: 13,
        x: 0,
        y: 9,
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
      links: [],
      nullPointMode: 'null as zero',
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
          expr: 'sum(increase(cloudwatch_requests_total[5m])) by (exported_namespace)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ namespace }}',
          refId: 'A',
        },
        {
          expr: 'sum(increase(cloudwatch_requests_total[5m]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: 'Total',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'API Call count',
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
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          color: {
            mode: 'thresholds',
          },
          custom: {
            align: null,
          },
          mappings: [],
          max: 100,
          min: 0,
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
      gridPos: {
        h: 11,
        w: 11,
        x: 13,
        y: 9,
      },
      id: 6,
      links: [],
      options: {
        showHeader: true,
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(increase(cloudwatch_requests_total[7d])) by (exported_namespace)',
          format: 'table',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ namespace }}',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'API Call Count - Comparison [7d]',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
            },
            indexByName: {},
            renameByName: {
              Time: '',
              Value: 'API Calls',
              exported_namespace: 'Namespace',
            },
          },
        },
      ],
      type: 'table',
    },
  ],
  schemaVersion: 25,
  style: 'dark',
  tags: [],
  templating: {
    list: [
      {
        current: {
          selected: true,
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
        queryValue: '',
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
    time_options: [
      '5m',
      '15m',
      '1h',
      '6h',
      '12h',
      '24h',
      '2d',
      '7d',
      '30d',
    ],
  },
  timezone: '',
  title: 'CloudWatch Exporter',
  uid: 'acw-dmKWz',
  version: 2,
};

local configmap(me) = grafana.dashboard(me, 'cloudwatch-exporter', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name == 'shared'
  then [
    configmap(me),
  ]
  else {}
)

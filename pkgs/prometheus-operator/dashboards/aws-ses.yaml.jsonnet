local common = import '../../../lib/common.jsonnet';
local grafana = import '../../../lib/grafana.jsonnet';
local lib = import '../../../lib/lib.jsonnet';

local dashboardConfig = {
  annotations: {
    list: [
      {
        builtIn: 1,
        datasource: 'Prometheus',
        enable: false,
        expr: 'ALERTS{alertname="SesBounceRateHigh"}',
        hide: true,
        iconColor: '#F2495C',
        limit: 100,
        name: 'Faiure rate above 5%',
        showIn: 0,
        step: '3600s',
        type: 'dashboard',
        useValueForTime: false,
      },
    ],
  },
  description: 'Visualize AWS SES metrics',
  editable: true,
  gnetId: 1519,
  graphTooltip: 0,
  id: 371,
  iteration: 1593729354751,
  links: [],
  panels: [
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '${datasource}',
      decimals: 2,
      editable: true,
      'error': false,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      grid: {},
      gridPos: {
        h: 7,
        w: 24,
        x: 0,
        y: 0,
      },
      hiddenSeries: false,
      id: 8,
      legend: {
        alignAsTable: true,
        avg: true,
        current: true,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'current',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'connected',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [
        {
          alias: 'Latency_Average',
          yaxis: 2,
        },
        {
          alias: 'TargetResponseTime_Average',
          yaxis: 2,
        },
        {
          alias: 'ClientConnections_Sum',
          yaxis: 2,
        },
        {
          alias: 'Delivery_Average',
          yaxis: 1,
        },
        {
          alias: 'Send_Average',
          yaxis: 2,
        },
        {
          alias: 'Bounce_Average',
          yaxis: 2,
        },
      ],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          alias: '',
          application: {
            filter: '',
          },
          dimensions: {},
          expr: 'sum(aws_ses_reputation_complaint_rate_sum) by(exported_job) * 100',
          functions: [],
          group: {
            filter: '',
          },
          host: {
            filter: '',
          },
          interval: '',
          item: {
            filter: '',
          },
          legendFormat: '{{ exported_job }}',
          metricName: 'Bounce',
          mode: 0,
          namespace: 'AWS/SES',
          options: {
            showDisabledItems: false,
          },
          period: '',
          refId: 'A',
          region: '$region',
          statistics: [
            'Average',
          ],
        },
      ],
      thresholds: [
        {
          colorMode: 'critical',
          fill: true,
          line: true,
          op: 'gt',
          value: 5,
          yaxis: 'left',
        },
      ],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Complaints',
      tooltip: {
        msResolution: false,
        shared: true,
        sort: 0,
        value_type: 'cumulative',
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
          decimals: 2,
          format: 'percent',
          label: null,
          logBase: 1,
          max: null,
          min: 0,
          show: true,
        },
        {
          format: 'none',
          label: null,
          logBase: 1,
          max: null,
          min: 0,
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
      dashLength: 10,
      dashes: false,
      datasource: '${datasource}',
      decimals: 2,
      editable: true,
      'error': false,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      grid: {},
      gridPos: {
        h: 7,
        w: 24,
        x: 0,
        y: 7,
      },
      hiddenSeries: false,
      id: 9,
      legend: {
        alignAsTable: true,
        avg: true,
        current: true,
        hideEmpty: false,
        hideZero: false,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'current',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'connected',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [
        {
          alias: 'Latency_Average',
          yaxis: 2,
        },
        {
          alias: 'TargetResponseTime_Average',
          yaxis: 2,
        },
        {
          alias: 'ClientConnections_Sum',
          yaxis: 2,
        },
        {
          alias: 'Delivery_Average',
          yaxis: 1,
        },
        {
          alias: 'Send_Average',
          yaxis: 2,
        },
      ],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          alias: '',
          application: {
            filter: '',
          },
          dimensions: {},
          expr: 'sum(aws_ses_reputation_bounce_rate_sum) by (exported_job) * 100',
          functions: [],
          group: {
            filter: '',
          },
          host: {
            filter: '',
          },
          instant: false,
          interval: '',
          item: {
            filter: '',
          },
          legendFormat: '{{ exported_job }}',
          metricName: 'Complaint',
          mode: 0,
          namespace: 'AWS/SES',
          options: {
            showDisabledItems: false,
          },
          period: '',
          refId: 'A',
          region: '$region',
          statistics: [
            'Average',
          ],
        },
      ],
      thresholds: [
        {
          colorMode: 'critical',
          fill: true,
          line: true,
          op: 'gt',
          value: 5,
          yaxis: 'left',
        },
      ],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Bounce rate',
      tooltip: {
        msResolution: false,
        shared: true,
        sort: 0,
        value_type: 'cumulative',
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
          decimals: 2,
          format: 'percent',
          label: null,
          logBase: 1,
          max: null,
          min: 0,
          show: true,
        },
        {
          format: 'none',
          label: null,
          logBase: 1,
          max: null,
          min: 0,
          show: false,
        },
      ],
      yaxis: {
        align: false,
        alignLevel: null,
      },
    },
  ],
  refresh: '1m',
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'cloudwatch',
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
        label: 'Datasource',
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
  timezone: 'utc',
  title: 'AWS / SES',
  uid: 'WojOgXTmkf2f',
  version: 10,
};

local configmap(me) = grafana.dashboard(me, 'aws-ses', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.getElse(me, 'opsMonitoring', false)
  then [
    configmap(me),
  ]
  else {}
)

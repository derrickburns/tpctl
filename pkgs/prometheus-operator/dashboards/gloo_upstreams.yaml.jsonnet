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
  links: [],
  panels: [
    {
      aliasColors: {
        '2xx': '#7eb26d',
        '4xx': '#eab839',
        '5xx': '#bf1b00',
      },
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
        h: 10,
        w: 24,
        x: 0,
        y: 0,
      },
      hiddenSeries: false,
      id: 6,
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_cluster_name!~".*(gloo-system|kube-svc).*"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'All Codes',
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
          '$$hashKey': 'object:1033',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1034',
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
      aliasColors: {
        '2xx': '#7eb26d',
        '4xx': '#eab839',
        '5xx': '#bf1b00',
      },
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
        h: 11,
        w: 12,
        x: 0,
        y: 10,
      },
      hiddenSeries: false,
      id: 2,
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="2", envoy_cluster_name!~".*(gloo-system|kube-svc).*"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '2xx Codes',
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
          '$$hashKey': 'object:1033',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1034',
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
      aliasColors: {
        '2xx': '#7eb26d',
        '4xx': '#eab839',
        '5xx': '#bf1b00',
      },
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
        h: 11,
        w: 12,
        x: 12,
        y: 10,
      },
      hiddenSeries: false,
      id: 3,
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="3", envoy_cluster_name!~".*(gloo-system|kube-svc).*"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '3xx Codes',
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
      aliasColors: {
        '2xx': '#7eb26d',
        '4xx': '#eab839',
        '5xx': '#bf1b00',
      },
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
        h: 11,
        w: 12,
        x: 0,
        y: 21,
      },
      hiddenSeries: false,
      id: 4,
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="4", envoy_cluster_name!~".*(gloo-system|kube-svc).*"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '4xx Codes',
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
      aliasColors: {
        '2xx': '#7eb26d',
        '4xx': '#eab839',
        '5xx': '#bf1b00',
      },
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
        h: 11,
        w: 12,
        x: 12,
        y: 21,
      },
      hiddenSeries: false,
      id: 5,
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: true,
        min: false,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="5", envoy_cluster_name!~".*(gloo-system|kube-svc).*"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '5xx Codes',
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
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'gloo',
    'network',
    'upstream',
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
  timezone: 'utc',
  title: 'Gloo Upstreams Summary',
  uid: '4EIm6BmGk',
  version: 2,
};

local configmap(me) = grafana.dashboard(me, 'gloo-upstreams', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

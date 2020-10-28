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
  description: 'Envoy proxy monitoring Dashboard with cluster and host level templates. ',
  editable: false,
  gnetId: null,
  graphTooltip: 0,
  iteration: 1603908167207,
  links: [],
  panels: [
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          links: [],
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 12,
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
      links: [],
      nullPointMode: 'null',
      options: {
        alertThreshold: true,
      },
      percentage: false,
      pluginVersion: '7.2.0',
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(envoy_cluster_upstream_cx_active{envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}) by (envoy_cluster_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{envoy_cluster_name}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Total Active Connections',
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
          '$$hashKey': 'object:783',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:784',
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
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          links: [],
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 12,
        x: 12,
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
        alertThreshold: true,
      },
      percentage: false,
      pluginVersion: '7.2.0',
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(envoy_cluster_upstream_rq_total{ envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (envoy_cluster_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{envoy_cluster_name}} ',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'RPS',
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
          '$$hashKey': 'object:453',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:454',
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
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          links: [],
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 12,
        x: 0,
        y: 7,
      },
      hiddenSeries: false,
      id: 15,
      legend: {
        alignAsTable: false,
        avg: false,
        current: false,
        max: false,
        min: false,
        rightSide: false,
        show: true,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        alertThreshold: true,
      },
      percentage: false,
      pluginVersion: '7.2.0',
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(envoy_cluster_upstream_cx_rx_bytes_total{ envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (envoy_cluster_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }} - in',
          refId: 'A',
        },
        {
          expr: 'sum(irate(envoy_cluster_upstream_cx_tx_bytes_total{ envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (envoy_cluster_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }} - out',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Upstream Network Traffic',
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
          '$$hashKey': 'object:1070',
          format: 'decbytes',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1071',
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
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      description: '',
      fieldConfig: {
        defaults: {
          custom: {},
          links: [],
          unit: 'percentunit',
        },
        overrides: [],
      },
      fill: 10,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 12,
        x: 12,
        y: 7,
      },
      hiddenSeries: false,
      id: 18,
      legend: {
        alignAsTable: true,
        avg: true,
        current: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 0,
      links: [],
      nullPointMode: 'null',
      options: {
        alertThreshold: true,
      },
      percentage: false,
      pluginVersion: '7.2.0',
      pointradius: 2,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: true,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(rate(envoy_cluster_upstream_rq_xx{envoy_response_code_class="2", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))/ sum(rate(envoy_cluster_upstream_rq_xx{gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '2xx',
          refId: 'A',
        },
        {
          expr: 'sum(rate(envoy_cluster_upstream_rq_xx{envoy_response_code_class="3", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))/sum(rate(envoy_cluster_upstream_rq_xx{gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '3xx',
          refId: 'B',
        },
        {
          expr: 'sum(rate(envoy_cluster_upstream_rq_xx{envoy_response_code_class="4", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))/sum(rate(envoy_cluster_upstream_rq_xx{gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '4xx',
          refId: 'C',
        },
        {
          expr: 'sum(rate(envoy_cluster_upstream_rq_xx{envoy_response_code_class="5", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))/sum(rate(envoy_cluster_upstream_rq_xx{gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[$__rate_interval]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '5xx',
          refId: 'D',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Code Class Percentage',
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
          '$$hashKey': 'object:536',
          format: 'percentunit',
          label: '',
          logBase: 1,
          max: '1',
          min: '0',
          show: true,
        },
        {
          '$$hashKey': 'object:537',
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
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          links: [],
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 12,
        x: 0,
        y: 14,
      },
      hiddenSeries: false,
      id: 19,
      legend: {
        alignAsTable: false,
        avg: false,
        current: false,
        max: false,
        min: false,
        rightSide: false,
        show: true,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        alertThreshold: true,
      },
      percentage: false,
      pluginVersion: '7.2.0',
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'histogram_quantile(0.999, sum(rate(envoy_cluster_upstream_rq_time_bucket{envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (le, envoy_cluster_name, namespace))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{namespace}}/{{envoy_cluster_name}} 99.9%',
          refId: 'A',
        },
        {
          expr: 'histogram_quantile(0.99, sum(rate(envoy_cluster_upstream_rq_time_bucket{envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (le, envoy_cluster_name, namespace))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{namespace}}/{{envoy_cluster_name}} 99%',
          refId: 'D',
        },
        {
          expr: 'histogram_quantile(0.9, sum(rate(envoy_cluster_upstream_rq_time_bucket{envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (le, envoy_cluster_name, namespace))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{namespace}}/{{envoy_cluster_name}} 90%',
          refId: 'B',
        },
        {
          expr: 'histogram_quantile(0.5, sum(rate(envoy_cluster_upstream_rq_time_bucket{envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[$__rate_interval])) by (le, envoy_cluster_name, namespace))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{namespace}}/{{envoy_cluster_name}} 50%',
          refId: 'C',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Upstream Latency',
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
          '$$hashKey': 'object:906',
          format: 'ms',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:907',
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
  refresh: '30s',
  schemaVersion: 26,
  style: 'dark',
  tags: [
    '$datasource',
    'dynamic',
  ],
  templating: {
    list: [
      {
        allValue: null,
        current: {
          selected: false,
          text: 'internal-gateway-proxy_gloo-system',
          value: 'internal-gateway-proxy_gloo-system',
        },
        datasource: '$datasource',
        definition: 'label_values(envoy_cluster_upstream_rq_total, envoy_cluster_name)',
        hide: 0,
        includeAll: false,
        label: 'Upstream',
        multi: false,
        name: 'upstream',
        options: [],
        query: 'label_values(envoy_cluster_upstream_rq_total, envoy_cluster_name)',
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 0,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
      },
      {
        allValue: null,
        current: {
          selected: true,
          text: [
            'All',
          ],
          value: [
            '$__all',
          ],
        },
        datasource: '$datasource',
        definition: 'label_values(envoy_http_downstream_rq_total, gateway_proxy_id)',
        hide: 0,
        includeAll: true,
        label: 'Proxy',
        multi: true,
        name: 'proxy',
        options: [],
        query: 'label_values(envoy_http_downstream_rq_total, gateway_proxy_id)',
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
  title: 'Gloo Upstreams',
  uid: 'gloo_upstreams',
  version: 4,
};

local configmap(me) = grafana.dashboard(me, 'gloo-upstreams', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

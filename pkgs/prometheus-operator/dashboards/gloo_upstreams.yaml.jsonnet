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
  editable: true,
  gnetId: null,
  graphTooltip: 0,
  iteration: 1591721200963,
  links: [],
  panels: [
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
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
          expr: 'sum(envoy_cluster_upstream_cx_active{envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 2,
          legendFormat: '{{envoy_cluster_name}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Total active connections in $upstream',
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
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
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
          expr: 'sum(irate(envoy_cluster_upstream_rq_total{ envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 2,
          legendFormat: '{{envoy_cluster_name}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Total requests in $upstream',
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
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
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
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(envoy_cluster_upstream_cx_rx_bytes_total{ envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }} - in',
          refId: 'A',
        },
        {
          expr: 'sum(irate(envoy_cluster_upstream_cx_tx_bytes_total{ envoy_cluster_name="$upstream", gateway_proxy_id=~"$proxy"}[1m])) by (envoy_cluster_name)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '{{ envoy_cluster_name }} - out',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Upstream Network Traffic in $upstream',
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
          format: 'decbytes',
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
      dashLength: 10,
      dashes: false,
      datasource: null,
      fill: 1,
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
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="2", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[1m]))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '2xx',
          refId: 'A',
        },
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="3", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[1m]))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '3xx',
          refId: 'B',
        },
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="4", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[1m]))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '4xx',
          refId: 'C',
        },
        {
          expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="5", gateway_proxy_id=~"$proxy", envoy_cluster_name="$upstream"}[1m]))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '5xx',
          refId: 'D',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Upstream Responses',
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
          label: 'RPM',
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
  refresh: '30s',
  schemaVersion: 22,
  style: 'dark',
  tags: [
    'Prometheus',
    'dynamic',
  ],
  templating: {
    list: [
      {
        allValue: null,
        current: {
          selected: true,
          text: 'jellyfish_qa2',
          value: 'jellyfish_qa2',
        },
        datasource: 'Prometheus',
        definition: 'label_values(envoy_cluster_name)',
        hide: 0,
        includeAll: false,
        label: 'Upstream',
        multi: false,
        name: 'upstream',
        options: [],
        query: 'label_values(envoy_cluster_name)',
        refresh: 1,
        regex: '^(?!.*gloo-system|kube-svc).*$',
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
          text: 'All',
          value: [
            '$__all',
          ],
        },
        datasource: 'Prometheus',
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
    ],
  },
  time: {
    from: 'now-6h',
    to: 'now',
  },
  timepicker: {
    refresh_intervals: [
      '5s',
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
  title: 'Gloo Upstreams',
  uid: 'gloo_upstreams',
  version: 3,
};

local configmap(me) = grafana.dashboard(me, 'gloo-upstreams', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

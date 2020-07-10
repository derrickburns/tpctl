local common = import '../../../../lib/common.jsonnet';
local grafana = import '../../../../lib/grafana.jsonnet';

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
  editable: true,
  gnetId: null,
  graphTooltip: 1,
  id: null,
  iteration: 1539806914987,
  links: [],
  panels: [
    {
      content: '<div style="display: flex; align-items: center">\n  <img src="https://linkerd.io/images/identity/favicon/linkerd-favicon.png" style="height:32px;"/>&nbsp;\n  <span style="font-size: 32px">route/$rt_route</span>\n</div>',
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 0,
      },
      id: 2,
      links: [],
      mode: 'html',
      options: {},
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: false,
      colors: [
        '#d44a3a',
        'rgba(237, 129, 40, 0.89)',
        '#299c46',
      ],
      datasource: 'Prometheus',
      decimals: null,
      format: 'percentunit',
      gauge: {
        maxValue: 1,
        minValue: 0,
        show: true,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 4,
        w: 8,
        x: 0,
        y: 2,
      },
      id: 4,
      interval: null,
      links: [],
      mappingType: 1,
      mappingTypes: [
        {
          name: 'value to text',
          value: 1,
        },
        {
          name: 'range to text',
          value: 2,
        },
      ],
      maxDataPoints: 100,
      nullPointMode: 'connected',
      nullText: null,
      options: {},
      postfix: '',
      postfixFontSize: '50%',
      prefix: '',
      prefixFontSize: '50%',
      rangeMaps: [
        {
          from: 'null',
          text: 'N/A',
          to: 'null',
        },
      ],
      sparkline: {
        fillColor: 'rgba(31, 118, 189, 0.18)',
        full: true,
        lineColor: 'rgb(31, 120, 193)',
        show: true,
      },
      tableColumn: '',
      targets: [
        {
          expr: 'sum(irate(route_response_total{classification="success", namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) / sum(irate(route_response_total{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s]))',
          format: 'time_series',
          instant: false,
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '0.9,.99',
      title: 'SUCCESS RATE',
      transparent: true,
      type: 'singlestat',
      valueFontSize: '80%',
      valueMaps: [
        {
          op: '=',
          text: 'N/A',
          value: 'null',
        },
      ],
      valueName: 'current',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: false,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: 'Prometheus',
      decimals: null,
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 4,
        w: 8,
        x: 8,
        y: 2,
      },
      id: 6,
      interval: null,
      links: [],
      mappingType: 1,
      mappingTypes: [
        {
          name: 'value to text',
          value: 1,
        },
        {
          name: 'range to text',
          value: 2,
        },
      ],
      maxDataPoints: 100,
      nullPointMode: 'connected',
      nullText: null,
      options: {},
      postfix: ' RPS',
      postfixFontSize: '100%',
      prefix: '',
      prefixFontSize: '50%',
      rangeMaps: [
        {
          from: 'null',
          text: 'N/A',
          to: 'null',
        },
      ],
      sparkline: {
        fillColor: 'rgba(31, 118, 189, 0.18)',
        full: true,
        lineColor: 'rgb(31, 120, 193)',
        show: true,
      },
      tableColumn: '',
      targets: [
        {
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s]))',
          format: 'time_series',
          instant: false,
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'REQUEST RATE',
      transparent: true,
      type: 'singlestat',
      valueFontSize: '100%',
      valueMaps: [
        {
          op: '=',
          text: 'N/A',
          value: 'null',
        },
      ],
      valueName: 'current',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: false,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: 'Prometheus',
      decimals: null,
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 4,
        w: 8,
        x: 16,
        y: 2,
      },
      id: 8,
      interval: null,
      links: [],
      mappingType: 1,
      mappingTypes: [
        {
          name: 'value to text',
          value: 1,
        },
        {
          name: 'range to text',
          value: 2,
        },
      ],
      maxDataPoints: 100,
      nullPointMode: 'connected',
      nullText: null,
      options: {},
      postfix: ' ms',
      postfixFontSize: '100%',
      prefix: '',
      prefixFontSize: '50%',
      rangeMaps: [
        {
          from: 'null',
          text: 'N/A',
          to: 'null',
        },
      ],
      sparkline: {
        fillColor: 'rgba(31, 118, 189, 0.18)',
        full: true,
        lineColor: 'rgb(31, 120, 193)',
        show: true,
      },
      tableColumn: '',
      targets: [
        {
          expr: 'histogram_quantile(0.95, sum(irate(route_response_latency_ms_bucket{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) by (le, rt_route))',
          format: 'time_series',
          instant: false,
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'P95 LATENCY',
      transparent: true,
      type: 'singlestat',
      valueFontSize: '100%',
      valueMaps: [
        {
          op: '=',
          text: 'N/A',
          value: 'null',
        },
      ],
      valueName: 'current',
    },
    {
      content: '<div class="text-center dashboard-header">\n  <span>TOP-LINE TRAFFIC</span>\n</div>',
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 6,
      },
      id: 10,
      links: [],
      mode: 'html',
      options: {},
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
      fill: 1,
      gridPos: {
        h: 7,
        w: 8,
        x: 0,
        y: 8,
      },
      id: 12,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'sum(irate(route_response_total{classification="success", namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) by (rt_route) / sum(irate(route_response_total{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) by (rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'route/{{rt_route}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'SUCCESS RATE',
      tooltip: {
        shared: true,
        sort: 2,
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
          decimals: null,
          format: 'percentunit',
          label: '',
          logBase: 1,
          max: '1',
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
      fill: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 8,
        y: 8,
      },
      id: 14,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="inbound", rt_route="$rt_route", tls="true"}[30s])) by (rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '🔒route/{{rt_route}}',
          refId: 'A',
        },
        {
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="inbound", rt_route="$rt_route", tls!="true"}[30s])) by (rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'route/{{rt_route}}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'REQUEST RATE',
      tooltip: {
        shared: true,
        sort: 2,
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
          decimals: null,
          format: 'rps',
          label: '',
          logBase: 1,
          max: null,
          min: '0',
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
      gridPos: {
        h: 7,
        w: 8,
        x: 16,
        y: 8,
      },
      id: 16,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'histogram_quantile(0.5, sum(irate(route_response_latency_ms_bucket{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) by (le, rt_route))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'p50 route/{{rt_route}}',
          refId: 'A',
        },
        {
          expr: 'histogram_quantile(0.95, sum(irate(route_response_latency_ms_bucket{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) by (le, rt_route))',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: 'p95 route/{{rt_route}}',
          refId: 'B',
        },
        {
          expr: 'histogram_quantile(0.99, sum(irate(route_response_latency_ms_bucket{namespace="$namespace", direction="inbound", rt_route="$rt_route"}[30s])) by (le, rt_route))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'p99 route/{{rt_route}}',
          refId: 'C',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'LATENCY',
      tooltip: {
        shared: true,
        sort: 2,
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
          decimals: null,
          format: 'ms',
          label: '',
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
      content: '<div class="text-center dashboard-header">\n  <span>INBOUND TRAFFIC BY DEPLOYMENT</span>\n</div>',
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 15,
      },
      id: 18,
      links: [],
      mode: 'html',
      options: {},
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
      fill: 1,
      gridPos: {
        h: 7,
        w: 8,
        x: 0,
        y: 17,
      },
      id: 20,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'sum(irate(route_response_total{classification="success", namespace="$namespace", direction="outbound", rt_route="$rt_route"}[30s])) by (deployment, rt_route) / sum(irate(route_response_total{namespace="$namespace", direction="outbound", rt_route="$rt_route"}[30s])) by (deployment, rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'deploy/{{deployment}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'SUCCESS RATE',
      tooltip: {
        shared: true,
        sort: 2,
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
          decimals: null,
          format: 'percentunit',
          label: '',
          logBase: 1,
          max: '1',
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
      fill: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 8,
        y: 17,
      },
      id: 22,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="outbound", tls="true", rt_route="$rt_route"}[30s])) by (deployment, rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '🔒deploy/{{deployment}}',
          refId: 'A',
        },
        {
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="outbound", tls!="true", rt_route="$rt_route"}[30s])) by (deployment, rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'deploy/{{deployment}}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'REQUEST RATE',
      tooltip: {
        shared: true,
        sort: 2,
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
          format: 'rps',
          label: '',
          logBase: 1,
          max: null,
          min: '0',
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
      gridPos: {
        h: 7,
        w: 8,
        x: 16,
        y: 17,
      },
      id: 24,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'histogram_quantile(0.95, sum(rate(route_response_latency_ms_bucket{namespace="$namespace", direction="outbound", rt_route="$rt_route"}[30s])) by (le, deployment, rt_route))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'P95 deploy/{{deployment}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'P95 LATENCY',
      tooltip: {
        shared: true,
        sort: 2,
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
          format: 'ms',
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
      content: '<div class="text-center dashboard-header">\n  <span>INBOUND TRAFFIC BY POD</span>\n</div>',
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 24,
      },
      id: 26,
      links: [],
      mode: 'html',
      options: {},
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: 'Prometheus',
      fill: 1,
      gridPos: {
        h: 7,
        w: 8,
        x: 0,
        y: 26,
      },
      id: 28,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'sum(irate(route_response_total{classification="success", namespace="$namespace", direction="outbound", rt_route="$rt_route"}[30s])) by (pod, rt_route) / sum(irate(route_response_total{namespace="$namespace", direction="outbound", rt_route="$rt_route"}[30s])) by (pod, rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'po/{{pod}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'SUCCESS RATE',
      tooltip: {
        shared: true,
        sort: 2,
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
          decimals: null,
          format: 'percentunit',
          label: '',
          logBase: 1,
          max: '1',
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
      fill: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 8,
        y: 26,
      },
      id: 30,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="outbound", tls="true", rt_route="$rt_route"}[30s])) by (pod, rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '🔒po/{{pod}}',
          refId: 'A',
        },
        {
          expr: 'sum(irate(route_request_total{namespace="$namespace", direction="outbound", tls!="true", rt_route="$rt_route"}[30s])) by (pod, rt_route)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'po/{{pod}}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'REQUEST RATE',
      tooltip: {
        shared: true,
        sort: 2,
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
          format: 'rps',
          label: '',
          logBase: 1,
          max: null,
          min: '0',
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
      gridPos: {
        h: 7,
        w: 8,
        x: 16,
        y: 26,
      },
      id: 32,
      legend: {
        avg: false,
        current: false,
        max: false,
        min: false,
        show: false,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 2,
      links: [],
      nullPointMode: 'null',
      options: {},
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
          expr: 'histogram_quantile(0.95, sum(rate(route_response_latency_ms_bucket{namespace="$namespace", direction="outbound", rt_route="$rt_route"}[30s])) by (le, pod))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'P95 po/{{pod, rt_route}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'P95 LATENCY',
      tooltip: {
        shared: true,
        sort: 2,
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
          format: 'ms',
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
      content: "<div>\n  <div style=\"position: absolute; top: 0, left: 0\">\n    <a href=\"https://linkerd.io\" target=\"_blank\"><img src=\"https://linkerd.io/images/identity/svg/linkerd_primary_color_white.svg\" style=\"height: 30px;\"></a>\n  </div>\n  <div id=\"version\" style=\"position: absolute; top: 0; right: 0; font-size: 15px\">\n  </div>\n</div>\n<script type=\"text/javascript\">\nvar localReqURL =\n  window.location.href.substring(\n    0,\n    window.location.href.indexOf(\n    \"/grafana/\"\n    )\n  )+'/overview';\n\nfetch(localReqURL, {\n  credentials: 'include',\n  headers: {\n    \"Content-Type\": \"text/html; charset=utf-8\",\n  },\n})\n.then(response => response.text())\n.then(text => (new window.DOMParser()).parseFromString(text, \"text/html\"))\n.then(html => {\n  var main = html.getElementById('main');\n  var localVersion = main.getAttribute(\"data-release-version\");\n  var versionElem = document.getElementById('version');\n\n  var channel;\n  var parts = localVersion.split(\"-\", 2);\n  if (parts.length === 2) {\n    channel = parts[0];\n    versionElem.innerHTML += 'Running Linkerd ' + parts[1] + ' (' + parts[0] + ')' + '.<br>';\n  } else {\n    versionElem.innerHTML += 'Running Linkerd ' + localVersion + '.<br>';\n  }\n  var uuid = main.getAttribute(\"data-uuid\");\n\n  fetch('https://versioncheck.linkerd.io/version.json?version='+localVersion+'&uuid='+uuid+'&source=grafana', {\n    credentials: 'include',\n    headers: {\n      \"Content-Type\": \"application/json; charset=utf-8\",\n    },\n  })\n  .then(response => response.json())\n  .then(json => {\n    if (!channel || !json[channel]) {\n      versionElem.innerHTML += 'Version check failed.'\n    } else if (json[channel] === localVersion) {\n      versionElem.innerHTML += 'Linkerd is up to date.';\n    } else {\n      parts = json[channel].split(\"-\", 2);\n      if (parts.length === 2) {\n        versionElem.innerHTML += \"A new \"+parts[0]+\" version (\"+parts[1]+\") is available.\"\n      } else {\n        versionElem.innerHTML += \"A new version (\"+json[channel]+\") is available.\"\n      }\n      versionElem.innerHTML += \" <a href='https://versioncheck.linkerd.io/update' target='_blank'>Update now</a>.\";\n    }\n  });\n});\n</script>",
      gridPos: {
        h: 3,
        w: 24,
        x: 0,
        y: 33,
      },
      height: '1px',
      id: 34,
      links: [],
      mode: 'html',
      options: {},
      title: '',
      transparent: true,
      type: 'text',
    },
  ],
  refresh: '1m',
  schemaVersion: 18,
  style: 'dark',
  tags: [
    'linkerd',
  ],
  templating: {
    list: [
      {
        allValue: null,
        current: {},
        datasource: 'Prometheus',
        definition: '',
        hide: 0,
        includeAll: false,
        label: 'Namespace',
        multi: false,
        name: 'namespace',
        options: [],
        query: 'label_values(route_request_total, namespace)',
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
      },
      {
        allValue: null,
        current: {},
        datasource: 'Prometheus',
        definition: '',
        hide: 0,
        includeAll: false,
        label: 'Route',
        multi: false,
        name: 'rt_route',
        options: [],
        query: 'label_values(route_request_total{namespace="$namespace"}, rt_route)',
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
      },
    ],
  },
  time: {
    from: 'now-5m',
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
  timezone: 'utc',
  title: 'Linkerd Route',
  uid: 'route',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'linkerd-route', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

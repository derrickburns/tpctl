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
  editable: true,
  gnetId: null,
  graphTooltip: 1,
  iteration: 1598039880170,
  links: [],
  panels: [
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#d44a3a',
        'rgba(237, 129, 40, 0.89)',
        '#299c46',
      ],
      datasource: 'Prometheus',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
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
        y: 0,
      },
      height: '',
      id: 28,
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
          expr: 'sum(irate(response_total{classification="success", namespace=~"$namespace", deployment=~"$deployment"}[30s])) / sum(irate(response_total{namespace=~"$namespace", deployment=~"$deployment"}[30s]))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '.9,.99',
      title: 'GLOBAL SUCCESS RATE',
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
        '#d44a3a',
        'rgba(237, 129, 40, 0.89)',
        '#299c46',
      ],
      datasource: 'Prometheus',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'rps',
      gauge: {
        maxValue: 1,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 4,
        w: 8,
        x: 8,
        y: 0,
      },
      height: '',
      id: 29,
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
          expr: 'sum(irate(request_total{namespace=~"$namespace", deployment=~"$deployment"}[30s]))',
          format: 'time_series',
          intervalFactor: 2,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'GLOBAL REQUEST VOLUME',
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
        '#d44a3a',
        'rgba(237, 129, 40, 0.89)',
        '#299c46',
      ],
      datasource: 'Prometheus',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 1,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 4,
        w: 8,
        x: 16,
        y: 0,
      },
      height: '',
      id: 86,
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
        show: false,
      },
      tableColumn: '',
      targets: [
        {
          expr: 'count(count(request_total{namespace=~"$namespace", deployment=~"$deployment"}) by (namespace, deployment))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'DEPLOYMENTS MONITORED',
      type: 'singlestat',
      valueFontSize: '200%',
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
      content: '<div class="text-center dashboard-header">\n  <span>TOP LINE</span>\n</div>',
      datasource: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 4,
      },
      height: '1px',
      id: 20,
      links: [],
      mode: 'html',
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 0,
        y: 6,
      },
      hiddenSeries: false,
      id: 21,
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
          expr: 'sum(irate(response_total{classification="success", namespace=~"$namespace", deployment=~"$deployment", direction="inbound"}[30s])) by (deployment) / sum(irate(response_total{namespace=~"$namespace", deployment=~"$deployment", direction="inbound"}[30s])) by (deployment)',
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
          format: 'percentunit',
          label: null,
          logBase: 1,
          max: 1,
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 8,
        y: 6,
      },
      hiddenSeries: false,
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
          expr: 'sum(irate(request_total{namespace=~"$namespace", deployment=~"$deployment", direction="inbound", tls="true"}[30s])) by (deployment)',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: '🔒deploy/{{deployment}}',
          refId: 'A',
        },
        {
          expr: 'sum(irate(request_total{namespace=~"$namespace", deployment=~"$deployment", direction="inbound", tls!="true"}[30s])) by (deployment)',
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
      title: 'REQUEST VOLUME',
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
          label: null,
          logBase: 1,
          max: null,
          min: 0,
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 16,
        y: 6,
      },
      hiddenSeries: false,
      id: 23,
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
          expr: 'histogram_quantile(0.95, sum(irate(response_latency_ms_bucket{namespace=~"$namespace", deployment=~"$deployment", direction="inbound"}[30s])) by (le, deployment))',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'p95 deploy/{{deployment}}',
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
      content: '<div class="text-center dashboard-header">\n  <span>DEPLOYMENTS</span>\n</div>',
      datasource: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 13,
      },
      height: '1px',
      id: 19,
      links: [],
      mode: 'html',
      title: '',
      transparent: true,
      type: 'text',
    },
    {
      collapsed: false,
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 15,
      },
      id: 40,
      panels: [],
      repeat: 'deployment',
      scopedVars: {
        deployment: {
          selected: true,
          text: 'data',
          value: 'data',
        },
      },
      title: '',
      type: 'row',
    },
    {
      content: '<div>\n  <img src="https://linkerd.io/images/identity/favicon/linkerd-favicon.png" style="baseline; height:30px;"/>&nbsp;\n  <a href="./dashboard/db/linkerd-deployment?var-namespace=$namespace&var-deployment=$deployment">\n    <span style="font-size: 15px; border-image:none">deploy/$deployment</span>\n  </a>\n</div>',
      datasource: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 16,
      },
      height: '1px',
      id: 13,
      links: [],
      mode: 'html',
      scopedVars: {
        deployment: {
          selected: true,
          text: 'data',
          value: 'data',
        },
      },
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 0,
        y: 18,
      },
      hiddenSeries: false,
      id: 6,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      scopedVars: {
        deployment: {
          selected: true,
          text: 'data',
          value: 'data',
        },
      },
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(response_total{classification="success", namespace="$namespace", deployment="$deployment", direction="inbound"}[20m])) by (deployment) / sum(irate(response_total{namespace="$namespace", deployment="$deployment", direction="inbound"}[20m])) by (deployment)',
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
          format: 'percentunit',
          label: null,
          logBase: 1,
          max: 1,
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 8,
        y: 18,
      },
      hiddenSeries: false,
      id: 8,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      scopedVars: {
        deployment: {
          selected: true,
          text: 'data',
          value: 'data',
        },
      },
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(request_total{namespace="$namespace", deployment="$deployment", direction="inbound", tls="true"}[30s])) by (deployment)',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: '🔒deploy/{{deployment}}',
          refId: 'A',
        },
        {
          expr: 'sum(irate(request_total{namespace="$namespace", deployment="$deployment", direction="inbound", tls!="true"}[30s])) by (deployment)',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: 'deploy/{{deployment}}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'REQUEST VOLUME',
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
          label: null,
          logBase: 1,
          max: null,
          min: 0,
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 16,
        y: 18,
      },
      hiddenSeries: false,
      id: 9,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      scopedVars: {
        deployment: {
          selected: true,
          text: 'data',
          value: 'data',
        },
      },
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'histogram_quantile(0.95, sum(irate(response_latency_ms_bucket{namespace="$namespace", deployment="$deployment", direction="inbound"}[30s])) by (le, deployment))',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: 'p95 deploy/{{deployment}}',
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
      collapsed: false,
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 25,
      },
      id: 87,
      panels: [],
      repeat: null,
      repeatIteration: 1598039880170,
      repeatPanelId: 40,
      scopedVars: {
        deployment: {
          selected: true,
          text: 'export',
          value: 'export',
        },
      },
      title: '',
      type: 'row',
    },
    {
      content: '<div>\n  <img src="https://linkerd.io/images/identity/favicon/linkerd-favicon.png" style="baseline; height:30px;"/>&nbsp;\n  <a href="./dashboard/db/linkerd-deployment?var-namespace=$namespace&var-deployment=$deployment">\n    <span style="font-size: 15px; border-image:none">deploy/$deployment</span>\n  </a>\n</div>',
      datasource: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 2,
        w: 24,
        x: 0,
        y: 26,
      },
      height: '1px',
      id: 88,
      links: [],
      mode: 'html',
      repeatIteration: 1598039880170,
      repeatPanelId: 13,
      repeatedByRow: true,
      scopedVars: {
        deployment: {
          selected: true,
          text: 'export',
          value: 'export',
        },
      },
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 0,
        y: 28,
      },
      hiddenSeries: false,
      id: 89,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      repeatIteration: 1598039880170,
      repeatPanelId: 6,
      repeatedByRow: true,
      scopedVars: {
        deployment: {
          selected: true,
          text: 'export',
          value: 'export',
        },
      },
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(response_total{classification="success", namespace="$namespace", deployment="$deployment", direction="inbound"}[20m])) by (deployment) / sum(irate(response_total{namespace="$namespace", deployment="$deployment", direction="inbound"}[20m])) by (deployment)',
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
          format: 'percentunit',
          label: null,
          logBase: 1,
          max: 1,
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 8,
        y: 28,
      },
      hiddenSeries: false,
      id: 90,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      repeatIteration: 1598039880170,
      repeatPanelId: 8,
      repeatedByRow: true,
      scopedVars: {
        deployment: {
          selected: true,
          text: 'export',
          value: 'export',
        },
      },
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(irate(request_total{namespace="$namespace", deployment="$deployment", direction="inbound", tls="true"}[30s])) by (deployment)',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: '🔒deploy/{{deployment}}',
          refId: 'A',
        },
        {
          expr: 'sum(irate(request_total{namespace="$namespace", deployment="$deployment", direction="inbound", tls!="true"}[30s])) by (deployment)',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: 'deploy/{{deployment}}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'REQUEST VOLUME',
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
          label: null,
          logBase: 1,
          max: null,
          min: 0,
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
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 8,
        x: 16,
        y: 28,
      },
      hiddenSeries: false,
      id: 91,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      repeatIteration: 1598039880170,
      repeatPanelId: 9,
      repeatedByRow: true,
      scopedVars: {
        deployment: {
          selected: true,
          text: 'export',
          value: 'export',
        },
      },
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'histogram_quantile(0.95, sum(irate(response_latency_ms_bucket{namespace="$namespace", deployment="$deployment", direction="inbound"}[30s])) by (le, deployment))',
          format: 'time_series',
          hide: false,
          intervalFactor: 1,
          legendFormat: 'p95 deploy/{{deployment}}',
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
  ],
  refresh: '1m',
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'linkerd',
  ],
  templating: {
    list: [
      {
        allValue: '.*',
        current: {
          selected: false,
          text: 'tidepool-prod',
          value: 'tidepool-prod',
        },
        datasource: 'Prometheus',
        definition: 'label_values(process_start_time_seconds{deployment!=""}, namespace)',
        hide: 0,
        includeAll: false,
        label: 'Namespace',
        multi: false,
        name: 'namespace',
        options: [],
        query: 'label_values(process_start_time_seconds{deployment!=""}, namespace)',
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
        allValue: '.*',
        current: {
          selected: true,
          tags: [],
          text: 'data + export',
          value: [
            'data',
            'export',
          ],
        },
        datasource: 'Prometheus',
        definition: 'label_values(process_start_time_seconds{namespace="$namespace"}, deployment)',
        hide: 0,
        includeAll: true,
        label: 'Deployments',
        multi: true,
        name: 'deployment',
        options: [],
        query: 'label_values(process_start_time_seconds{namespace="$namespace"}, deployment)',
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
  title: 'Linkerd Topline',
  uid: 'linkerd-topline',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'linkerd-topline', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

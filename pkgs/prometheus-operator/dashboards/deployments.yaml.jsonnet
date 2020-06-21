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
  description: 'Dashboard for Kubernetes deployment with Prometheus.',
  editable: true,
  gnetId: 9679,
  graphTooltip: 0,
  id: 26,
  iteration: 1592740562243,
  links: [],
  panels: [
    {
      collapsed: false,
      datasource: '$datasource',
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 0,
      },
      id: 51,
      panels: [],
      title: 'Usage',
      type: 'row',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#e24d42',
        '#f9934e',
        '#e0f9d7',
      ],
      datasource: '$datasource',
      decimals: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 0,
        y: 1,
      },
      id: 46,
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
      postfixFontSize: '30%',
      prefix: '',
      prefixFontSize: '30%',
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
          expr: 'sum( kube_deployment_status_replicas_available{namespace=~"^$Namespace$",deployment=~"^$Deployment"} )',
          format: 'time_series',
          instant: false,
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '1,2',
      title: 'Pods',
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
      cacheTimeout: null,
      colorBackground: false,
      colorPostfix: false,
      colorPrefix: false,
      colorValue: true,
      colors: [
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'percent',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: true,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 6,
        y: 1,
      },
      id: 31,
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
        full: false,
        lineColor: 'rgb(31, 120, 193)',
        show: false,
      },
      tableColumn: '',
      targets: [
        {
          expr: 'sum (rate (container_cpu_usage_seconds_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m])) / sum (kube_pod_container_resource_requests_cpu_cores{namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}) * 100',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '65, 90',
      title: 'CPU Usage',
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
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      decimals: 3,
      editable: true,
      'error': false,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 0,
      fillGradient: 0,
      grid: {},
      gridPos: {
        h: 7,
        w: 12,
        x: 12,
        y: 1,
      },
      height: '',
      hiddenSeries: false,
      id: 17,
      isNew: true,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        sideWidth: 200,
        sort: 'current',
        sortDesc: true,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'connected',
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
          expr: 'sum (rate (container_cpu_usage_seconds_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m])) by (pod_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ pod_name }}',
          metric: 'container_cpu',
          refId: 'A',
          step: 10,
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'CPU Usage (2m avg)',
      tooltip: {
        msResolution: true,
        shared: true,
        sort: 2,
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
          format: 'none',
          label: 'cores',
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
          show: false,
        },
      ],
      yaxis: {
        align: false,
        alignLevel: null,
      },
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#e24d42',
        '#f9934e',
        '#e0f9d7',
      ],
      datasource: '$datasource',
      decimals: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 3,
        x: 0,
        y: 6,
      },
      id: 52,
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
      postfixFontSize: '30%',
      prefix: '',
      prefixFontSize: '30%',
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
          expr: 'sum( kube_deployment_status_replicas_updated{namespace=~"^$Namespace$",deployment=~"^$Deployment"} )',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '1,2',
      title: 'Updated',
      type: 'singlestat',
      valueFontSize: '50%',
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
      colorPrefix: false,
      colorValue: true,
      colors: [
        '#e0f9d7',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: null,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 3,
        x: 3,
        y: 6,
      },
      id: 53,
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
      postfixFontSize: '30%',
      prefix: '',
      prefixFontSize: '30%',
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
          expr: 'sum( kube_deployment_status_replicas_unavailable{namespace=~"^$Namespace$",deployment=~"^$Deployment"} )',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '1,5',
      title: 'Unavailable',
      type: 'singlestat',
      valueFontSize: '50%',
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
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: 3,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 2,
        x: 6,
        y: 6,
      },
      id: 35,
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
      postfix: ' cores',
      postfixFontSize: '30%',
      prefix: '',
      prefixFontSize: '30%',
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
          expr: 'sum (rate (container_cpu_usage_seconds_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m]))',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'Used',
      type: 'singlestat',
      valueFontSize: '50%',
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
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: 3,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 2,
        x: 8,
        y: 6,
      },
      id: 37,
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
      postfix: ' cores',
      postfixFontSize: '30%',
      prefix: '',
      prefixFontSize: '30%',
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
          expr: 'sum (kube_pod_container_resource_requests_cpu_cores{container!="istio-proxy",namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'Requests',
      type: 'singlestat',
      valueFontSize: '50%',
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
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: 3,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'none',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 2,
        x: 10,
        y: 6,
      },
      id: 44,
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
      postfix: ' cores',
      postfixFontSize: '30%',
      prefix: '',
      prefixFontSize: '30%',
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
          expr: 'sum (kube_pod_container_resource_limits_cpu_cores{container!="istio-proxy",namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'Limits',
      type: 'singlestat',
      valueFontSize: '50%',
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
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 6,
        x: 0,
        y: 8,
      },
      hiddenSeries: false,
      id: 27,
      legend: {
        alignAsTable: true,
        avg: false,
        current: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        sideWidth: null,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'connected',
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
      steppedLine: true,
      targets: [
        {
          expr: 'sum( kube_deployment_status_replicas_updated{namespace=~"^$Namespace$",deployment=~"^$Deployment"} )',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: 'updated',
          refId: 'A',
        },
        {
          expr: 'sum( kube_deployment_status_replicas_available{namespace=~"^$Namespace$",deployment=~"^$Deployment"} )',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'available',
          refId: 'B',
        },
        {
          expr: 'sum( kube_deployment_status_replicas_unavailable{namespace=~"^$Namespace$",deployment=~"^$Deployment"} )',
          format: 'time_series',
          intervalFactor: 1,
          legendFormat: 'unavailable',
          refId: 'C',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Replicas',
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
          format: 'short',
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
          show: false,
        },
      ],
      yaxis: {
        align: false,
        alignLevel: null,
      },
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'percent',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: true,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 6,
        y: 8,
      },
      id: 33,
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
        full: false,
        lineColor: 'rgb(31, 120, 193)',
        show: false,
      },
      tableColumn: '',
      targets: [
        {
          expr: 'sum (container_memory_working_set_bytes{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}) / sum (kube_pod_container_resource_requests_memory_bytes{namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}) * 100',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '65,90',
      title: 'Memory Usage',
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
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      decimals: 2,
      editable: true,
      'error': false,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 0,
      fillGradient: 0,
      grid: {},
      gridPos: {
        h: 7,
        w: 12,
        x: 12,
        y: 8,
      },
      hiddenSeries: false,
      id: 25,
      isNew: true,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        sideWidth: 200,
        sort: 'current',
        sortDesc: true,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'connected',
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
          expr: 'sum (container_memory_working_set_bytes{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}) by (pod_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ pod_name }}',
          metric: 'container_memory_usage:sort_desc',
          refId: 'A',
          step: 10,
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Memory Usage',
      tooltip: {
        msResolution: false,
        shared: true,
        sort: 2,
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
          show: false,
        },
      ],
      yaxis: {
        align: false,
        alignLevel: null,
      },
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: false,
      colors: [
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: 2,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'bytes',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 2,
        x: 6,
        y: 13,
      },
      id: 39,
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
      postfixFontSize: '20%',
      prefix: '',
      prefixFontSize: '20%',
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
          expr: 'sum (container_memory_working_set_bytes{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'Used',
      type: 'singlestat',
      valueFontSize: '50%',
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
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: 2,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'bytes',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 2,
        x: 8,
        y: 13,
      },
      id: 41,
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
      postfixFontSize: '20%',
      prefix: '',
      prefixFontSize: '20%',
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
          expr: 'sum (kube_pod_container_resource_requests_memory_bytes{container!="istio-proxy",namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'Requests',
      type: 'singlestat',
      valueFontSize: '50%',
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
        '#629e51',
        '#f9934e',
        '#e24d42',
      ],
      datasource: '$datasource',
      decimals: 2,
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      format: 'bytes',
      gauge: {
        maxValue: 100,
        minValue: 0,
        show: false,
        thresholdLabels: false,
        thresholdMarkers: true,
      },
      gridPos: {
        h: 2,
        w: 2,
        x: 10,
        y: 13,
      },
      id: 45,
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
      postfixFontSize: '20%',
      prefix: '',
      prefixFontSize: '20%',
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
          expr: 'sum (kube_pod_container_resource_limits_memory_bytes{container!="istio-proxy",namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          intervalFactor: 1,
          refId: 'A',
        },
      ],
      thresholds: '',
      title: 'Limits',
      type: 'singlestat',
      valueFontSize: '50%',
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
      aliasColors: {},
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
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
        w: 12,
        x: 0,
        y: 15,
      },
      hiddenSeries: false,
      id: 16,
      isNew: true,
      legend: {
        alignAsTable: true,
        avg: false,
        current: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        sideWidth: null,
        sort: 'current',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'connected',
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
          expr: 'sum (rate (container_network_receive_bytes_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m])) by (pod_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '-> {{ pod_name }}',
          metric: 'network',
          refId: 'A',
          step: 10,
        },
        {
          expr: '- sum (rate (container_network_transmit_bytes_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m])) by (pod_name)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '<- {{ pod_name }}',
          metric: 'network',
          refId: 'B',
          step: 10,
        },
        {
          expr: 'sum (rate (container_network_receive_bytes_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '-> $Deployment',
          refId: 'C',
        },
        {
          expr: '- sum (rate (container_network_transmit_bytes_total{image!="",name=~"^k8s_.*",namespace=~"^$Namespace$",pod_name=~"^$Deployment-[a-z0-9]+-[a-z0-9]+"}[2m]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '<- $Deployment ',
          refId: 'D',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Network I/O (2m avg)',
      tooltip: {
        msResolution: false,
        shared: true,
        sort: 2,
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
          format: 'Bps',
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
          show: false,
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
      decimals: 0,
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
        w: 12,
        x: 12,
        y: 15,
      },
      hiddenSeries: false,
      id: 55,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
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
      pointradius: 3,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'increase(kube_pod_container_status_restarts_total{namespace=~"^$Namespace$",pod=~"^$Deployment-[a-z0-9]+-[a-z0-9]+", container=~"^$Deployment"}[10m])',
          interval: '',
          legendFormat: '{{ pod }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Pod Restarts',
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
          format: 'none',
          label: 'restarts',
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
  refresh: '10s',
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'kubernetes',
    'prometheus',
  ],
  templating: {
    list: [
      {
        allValue: '.*',
        current: {
          selected: false,
          text: 'administration',
          value: 'administration',
        },
        datasource: '$datasource',
        definition: '',
        hide: 0,
        includeAll: false,
        label: null,
        multi: false,
        name: 'Namespace',
        options: [],
        query: 'label_values(kube_namespace_labels, namespace)',
        refresh: 1,
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
          selected: false,
          text: 'All',
          value: '$__all',
        },
        datasource: '$datasource',
        definition: '',
        hide: 0,
        includeAll: true,
        label: null,
        multi: false,
        name: 'Deployment',
        options: [],
        query: 'label_values(kube_deployment_labels{namespace=~"^$Namespace$"}, deployment)',
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
        current: {
          selected: false,
          text: 'prometheus',
          value: 'prometheus',
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
    from: 'now-24h',
    to: 'now',
  },
  timepicker: {
    refresh_intervals: [
      '10s',
      '30s',
      '2m',
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
  timezone: 'browser',
  title: 'Kubernetes / Deployment / All',
  uid: 'kube-deployment',
  version: 3,
};

local configmap(me) = grafana.dashboard(me, 'kubernetes-deployments', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

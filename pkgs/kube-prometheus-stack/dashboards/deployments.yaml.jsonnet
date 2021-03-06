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
  editable: false,
  gnetId: 9679,
  graphTooltip: 0,
  iteration: 1597175308260,
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
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: '#e24d42',
                value: null,
              },
              {
                color: '#f9934e',
                value: 1,
              },
              {
                color: '#e0f9d7',
                value: 2,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_deployment_status_replicas_available{namespace=~"$namespace",deployment=~"$deployment"} )',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Pods',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          max: 100,
          min: 0,
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: '#629e51',
                value: null,
              },
              {
                color: '#f9934e',
                value: 65,
              },
              {
                color: '#e24d42',
                value: 90,
              },
            ],
          },
          unit: 'percent',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
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
          expr: 'sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate{namespace=~"$namespace",pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"}) / sum (kube_pod_container_resource_requests_cpu_cores{namespace=~"$namespace",pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"}) * 100',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'CPU Usage',
      type: 'gauge',
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
          expr: 'sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate{namespace=~"$namespace",pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"}) by (pod)',
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
      title: 'CPU Usage',
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
          '$$hashKey': 'object:206',
          format: 'none',
          label: 'cores',
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:207',
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
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: '#e24d42',
                value: null,
              },
              {
                color: '#f9934e',
                value: 1,
              },
              {
                color: '#e0f9d7',
                value: 2,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_deployment_status_replicas_updated{namespace=~"$namespace",deployment=~"$deployment"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Updated',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: '#e0f9d7',
                value: null,
              },
              {
                color: '#f9934e',
                value: 1,
              },
              {
                color: '#e24d42',
                value: 5,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_deployment_status_replicas_unavailable{namespace=~"$namespace",deployment=~"$deployment"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Unavailable',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          decimals: 3,
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
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
          unit: 'none',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate{namespace=~"$namespace",pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", container!="POD", container!=""})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Used',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          decimals: 3,
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
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
          unit: 'none',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_pod_container_resource_requests_cpu_cores{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Requests',
      transformations: [],
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          decimals: 3,
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
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
          unit: 'short',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_pod_container_resource_limits_cpu_cores{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Limits',
      type: 'stat',
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
          expr: 'sum(kube_deployment_status_replicas_updated{namespace=~"$namespace",deployment=~"$deployment"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: 'updated',
          refId: 'A',
        },
        {
          expr: 'sum(kube_deployment_status_replicas_available{namespace=~"$namespace",deployment=~"$deployment"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: 'available',
          refId: 'B',
        },
        {
          expr: 'sum(kube_deployment_status_replicas_unavailable{namespace=~"$namespace",deployment=~"$deployment"})',
          format: 'time_series',
          interval: '',
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
          '$$hashKey': 'object:891',
          format: 'short',
          label: '',
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:892',
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
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          max: 100,
          min: 0,
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: '#629e51',
                value: null,
              },
              {
                color: '#f9934e',
                value: 65,
              },
              {
                color: '#e24d42',
                value: 90,
              },
            ],
          },
          unit: 'percent',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
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
          expr: 'sum(container_memory_working_set_bytes{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!="POD", container!=""}) / sum(kube_pod_container_resource_requests_memory_bytes{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"}) * 100',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Memory Usage',
      type: 'gauge',
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
          expr: 'sum(container_memory_working_set_bytes{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!="POD", container!=""}) by (pod_name)',
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
          '$$hashKey': 'object:123',
          format: 'bytes',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:124',
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
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          decimals: 2,
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
            ],
          },
          unit: 'bytes',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(container_memory_working_set_bytes{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!="POD", container!=""})',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Used',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          decimals: 2,
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
            ],
          },
          unit: 'bytes',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_pod_container_resource_requests_memory_bytes{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Requests',
      type: 'stat',
    },
    {
      cacheTimeout: null,
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          decimals: 2,
          mappings: [
            {
              id: 0,
              op: '=',
              text: 'N/A',
              type: 1,
              value: 'null',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
            ],
          },
          unit: 'bytes',
        },
        overrides: [],
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
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'lastNotNull',
          ],
        },
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'horizontal',
        reduceOptions: {
          calcs: [
            'lastNotNull',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'sum(kube_pod_container_resource_limits_memory_bytes{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+"})',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      title: 'Limits',
      type: 'stat',
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
          expr: 'sum(irate(container_network_receive_bytes_total{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!=""}[5m])) by (pod)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '-> {{ pod }}',
          metric: 'network',
          refId: 'A',
          step: 10,
        },
        {
          expr: '- sum(irate(container_network_transmit_bytes_total{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!=""}[5m])) by (pod)',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '<- {{ pod }}',
          metric: 'network',
          refId: 'B',
          step: 10,
        },
        {
          expr: 'sum(irate(container_network_receive_bytes_total{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!=""}[5m]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '-> $deployment',
          refId: 'C',
        },
        {
          expr: '- sum(irate(container_network_transmit_bytes_total{namespace=~"$namespace", pod=~"$deployment-[a-z0-9]+-[a-z0-9]+", image!="", container!=""}[5m]))',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '<- $deployment ',
          refId: 'D',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Network I/O',
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
          '$$hashKey': 'object:1047',
          format: 'Bps',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1048',
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
          expr: 'increase(kube_pod_container_status_restarts_total{namespace=~"$namespace",pod=~"^$deployment-[a-z0-9]+-[a-z0-9]+", container=~"^$deployment"}[10m])',
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
          '$$hashKey': 'object:2222',
          decimals: 0,
          format: 'none',
          label: 'restarts',
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:2223',
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
          text: 'tidepool-prod',
          value: 'tidepool-prod',
        },
        datasource: '$datasource',
        definition: '',
        hide: 0,
        includeAll: false,
        label: 'Namespace',
        multi: false,
        name: 'namespace',
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
          text: 'export',
          value: 'export',
        },
        datasource: '$datasource',
        definition: 'label_values(kube_deployment_labels{namespace=~"$namespace"}, deployment)',
        hide: 0,
        includeAll: false,
        label: 'Deployment',
        multi: false,
        name: 'deployment',
        options: [],
        query: 'label_values(kube_deployment_labels{namespace=~"$namespace"}, deployment)',
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
  timezone: 'utc',
  title: 'Kubernetes / Deployment / All',
  uid: 'kube-deployment',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'kubernetes-deployments', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

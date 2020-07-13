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
  iteration: 1594642667747,
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
          custom: {
            align: null,
          },
          mappings: [],
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
          unit: 'bytes',
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'service',
            },
            properties: [
              {
                id: 'custom.width',
                value: 254,
              },
            ],
          },
          {
            matcher: {
              id: 'byName',
              options: 'target_kind',
            },
            properties: [
              {
                id: 'custom.width',
                value: 186,
              },
            ],
          },
        ],
      },
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 10,
        w: 12,
        x: 0,
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
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pluginVersion: '7.0.3',
      pointradius: 2,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target{namespace=~"$namespace",resource="cpu", verticalpodautoscaler=~"$vpa", container=~"$container"}) by (container, namespace, verticalpodautoscaler)',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'target - {{ container }}',
          refId: 'A',
        },
        {
          expr: 'sum(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_lowerbound{namespace=~"$namespace",resource="cpu", verticalpodautoscaler=~"$vpa", container=~"$container"}) by (container, namespace, verticalpodautoscaler)',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'lower bound - {{ container }}',
          refId: 'B',
        },
        {
          expr: 'sum(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_upperbound{namespace=~"$namespace",resource="cpu", verticalpodautoscaler=~"$vpa", container=~"$container"}) by (container, namespace, verticalpodautoscaler)',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'upper bound - {{ container }}',
          refId: 'C',
        },
        {
          expr: 'avg(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate{namespace=~"$namespace", pod=~"$vpa.*", container=~"$container"}) by (container)',
          interval: '',
          legendFormat: 'usage - {{ container }}',
          refId: 'D',
        },
        {
          expr: 'avg(kube_pod_container_resource_requests_cpu_cores{container=~"$container", namespace="$namespace", pod=~"$vpa.*"}) by (container)',
          interval: '',
          legendFormat: 'requests - {{ container }}',
          refId: 'E',
        },
        {
          expr: 'avg(kube_pod_container_resource_limits_cpu_cores{container=~"$container", namespace="$namespace", pod=~"$vpa.*"}) by (container)',
          interval: '',
          legendFormat: 'limits - {{ container }}',
          refId: 'F',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'CPU',
      tooltip: {
        shared: true,
        sort: 0,
        value_type: 'individual',
      },
      transformations: [],
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
          '$$hashKey': 'object:1314',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1315',
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
          custom: {
            align: null,
          },
          mappings: [],
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
          unit: 'bytes',
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'service',
            },
            properties: [
              {
                id: 'custom.width',
                value: 254,
              },
            ],
          },
          {
            matcher: {
              id: 'byName',
              options: 'target_kind',
            },
            properties: [
              {
                id: 'custom.width',
                value: 186,
              },
            ],
          },
        ],
      },
      fill: 0,
      fillGradient: 0,
      gridPos: {
        h: 10,
        w: 12,
        x: 12,
        y: 0,
      },
      hiddenSeries: false,
      id: 3,
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
      options: {
        dataLinks: [],
      },
      percentage: false,
      pluginVersion: '7.0.3',
      pointradius: 2,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target{namespace=~"$namespace",resource="memory", verticalpodautoscaler=~"$vpa", container=~"$container"}) by (container, namespace, verticalpodautoscaler)',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'target - {{ container }} ',
          refId: 'A',
        },
        {
          expr: 'sum(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_lowerbound{namespace=~"$namespace",resource="memory", verticalpodautoscaler=~"$vpa", container=~"$container"}) by (container, namespace, verticalpodautoscaler)',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'lower bound - {{ container }}',
          refId: 'B',
        },
        {
          expr: 'sum(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_upperbound{namespace=~"$namespace",resource="memory", verticalpodautoscaler=~"$vpa", container=~"$container"}) by (container, namespace, verticalpodautoscaler)',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'upper bound - {{ container }}',
          refId: 'C',
        },
        {
          expr: 'avg(container_memory_working_set_bytes{namespace="$namespace", pod=~"$vpa.*", container=~"$container"}) by (container)',
          interval: '',
          legendFormat: 'usage - {{ container }}',
          refId: 'D',
        },
        {
          expr: 'avg(\n    kube_pod_container_resource_requests_memory_bytes{namespace="$namespace", pod=~"$vpa.*", container=~"$container"}) by (container)',
          interval: '',
          legendFormat: 'requests - {{ container }}',
          refId: 'E',
        },
        {
          expr: 'avg(kube_pod_container_resource_limits_memory_bytes{namespace="$namespace", pod=~"$vpa.*", container=~"$container"}) by (container)',
          interval: '',
          legendFormat: 'limits - {{ container }}',
          refId: 'F',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Memory',
      tooltip: {
        shared: true,
        sort: 0,
        value_type: 'individual',
      },
      transformations: [],
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
          '$$hashKey': 'object:798',
          format: 'bytes',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:799',
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
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {
            align: null,
          },
          mappings: [
            {
              from: '',
              id: 0,
              operator: '',
              text: 'true',
              to: '',
              type: 1,
              value: '1',
            },
          ],
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
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'service',
            },
            properties: [
              {
                id: 'custom.width',
                value: 254,
              },
            ],
          },
          {
            matcher: {
              id: 'byName',
              options: 'target_kind',
            },
            properties: [
              {
                id: 'custom.width',
                value: 186,
              },
            ],
          },
        ],
      },
      gridPos: {
        h: 5,
        w: 24,
        x: 0,
        y: 10,
      },
      id: 2,
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: false,
            displayName: 'verticalpodautoscaler',
          },
        ],
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'kube_verticalpodautoscaler_spec_updatepolicy_updatemode{namespace=~"$namespace", verticalpodautoscaler=~"$vpa"} > 0',
          format: 'table',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Update mode',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              endpoint: true,
              instance: true,
              job: true,
              pod: true,
              resource: true,
              service: true,
              target_api_version: true,
              unit: true,
              verticalpodautoscaler: false,
            },
            indexByName: {
              Time: 0,
              Value: 12,
              __name__: 1,
              endpoint: 2,
              instance: 3,
              job: 4,
              namespace: 5,
              pod: 6,
              service: 7,
              target_api_version: 8,
              target_kind: 9,
              target_name: 10,
              update_mode: 13,
              verticalpodautoscaler: 11,
            },
            renameByName: {
              target_api_version: '',
              target_kind: 'Target Kind',
              target_name: 'Target name',
              update_mode: 'Update mode',
              verticalpodautoscaler: 'VPA',
            },
          },
        },
      ],
      type: 'table',
    },
  ],
  refresh: false,
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'autoscaler',
    'kubernetes',
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
          text: 'tidepool-prod',
          value: 'tidepool-prod',
        },
        datasource: '$datasource',
        definition: 'label_values(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target, namespace)',
        hide: 0,
        includeAll: false,
        label: 'Namespace',
        multi: false,
        name: 'namespace',
        options: [],
        query: 'label_values(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target, namespace)',
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
        allValue: null,
        current: {
          selected: true,
          text: 'blip',
          value: 'blip',
        },
        datasource: '$datasource',
        definition: 'label_values(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target{namespace=~"$namespace"}, verticalpodautoscaler)',
        hide: 0,
        includeAll: false,
        label: 'VPA',
        multi: false,
        name: 'vpa',
        options: [],
        query: 'label_values(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target{namespace=~"$namespace"}, verticalpodautoscaler)',
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
        allValue: null,
        current: {
          selected: false,
          text: 'blip',
          value: 'blip',
        },
        datasource: '$datasource',
        definition: 'label_values(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target{namespace=~"$namespace", verticalpodautoscaler=~"$vpa"}, container)',
        hide: 0,
        includeAll: false,
        label: 'Container',
        multi: false,
        name: 'container',
        options: [],
        query: 'label_values(kube_verticalpodautoscaler_status_recommendation_containerrecommendations_target{namespace=~"$namespace", verticalpodautoscaler=~"$vpa"}, container)',
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
  timezone: 'utc',
  title: 'Kubernetes / Autoscaler / Vertical Pod Autoscaler',
  uid: '3u1XTUGMz',
  version: 5,
};

local configmap(me) = grafana.dashboard(me, 'vpa', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

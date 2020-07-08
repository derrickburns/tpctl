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
  id: 280,
  iteration: 1594202137951,
  links: [],
  panels: [
    {
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
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 0,
        y: 0,
      },
      id: 3,
      options: {
        colorMode: 'value',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'kube_poddisruptionbudget_status_desired_healthy{poddisruptionbudget=~"$pdb"}',
          format: 'time_series',
          instant: true,
          interval: '',
          legendFormat: 'Currently healthy',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Desired healthy',
      type: 'stat',
    },
    {
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
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 6,
        y: 0,
      },
      id: 4,
      options: {
        colorMode: 'value',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'kube_poddisruptionbudget_status_current_healthy{poddisruptionbudget=~"$pdb"}',
          format: 'time_series',
          instant: true,
          interval: '',
          legendFormat: 'Currently healthy',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Currently healthy',
      type: 'stat',
    },
    {
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
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 12,
        y: 0,
      },
      id: 5,
      options: {
        colorMode: 'value',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'kube_poddisruptionbudget_status_pod_disruptions_allowed{poddisruptionbudget=~"$pdb"}',
          format: 'time_series',
          instant: true,
          interval: '',
          legendFormat: 'Currently healthy',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Disruptions allowed',
      type: 'stat',
    },
    {
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
        },
        overrides: [],
      },
      gridPos: {
        h: 5,
        w: 6,
        x: 18,
        y: 0,
      },
      id: 6,
      options: {
        colorMode: 'value',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: [
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'kube_poddisruptionbudget_status_current_healthy{poddisruptionbudget=~"$pdb"}',
          format: 'time_series',
          instant: true,
          interval: '',
          legendFormat: 'Currently healthy',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Expected pods',
      type: 'stat',
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
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 9,
        w: 24,
        x: 0,
        y: 5,
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
          expr: 'kube_poddisruptionbudget_status_current_healthy{poddisruptionbudget=~"$pdb"}',
          format: 'time_series',
          instant: false,
          interval: '',
          legendFormat: 'Currently healthy',
          refId: 'A',
        },
        {
          expr: 'kube_poddisruptionbudget_status_expected_pods{poddisruptionbudget=~"$pdb"}',
          interval: '',
          legendFormat: 'Expected',
          refId: 'B',
        },
        {
          expr: 'kube_poddisruptionbudget_status_desired_healthy{poddisruptionbudget=~"$pdb"}',
          interval: '',
          legendFormat: 'Desired',
          refId: 'C',
        },
        {
          expr: 'kube_poddisruptionbudget_status_pod_disruptions_allowed{poddisruptionbudget=~"$pdb"}',
          interval: '',
          legendFormat: 'Disruptions allowed',
          refId: 'D',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '$pdb Status',
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
    'autoscaler',
    'kubernetes',
  ],
  templating: {
    list: [
      {
        current: {
          selected: false,
          text: 'prometheus',
          value: 'prometheus',
        },
        hide: 2,
        includeAll: false,
        label: '',
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
          selected: true,
          tags: [],
          text: 'ingress-nginx-controller',
          value: [
            'ingress-nginx-controller',
          ],
        },
        datasource: '$datasource',
        definition: 'label_values(kube_poddisruptionbudget_status_current_healthy{}, poddisruptionbudget)',
        hide: 0,
        includeAll: false,
        label: 'Pod Disruption Budget',
        multi: true,
        name: 'pdb',
        options: [],
        query: 'label_values(kube_poddisruptionbudget_status_current_healthy{}, poddisruptionbudget)',
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
  timezone: '',
  title: 'Kubernetes / Autoscaler / Pod Disruption Budget',
  uid: 'bTvhizMGz',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'pdb', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

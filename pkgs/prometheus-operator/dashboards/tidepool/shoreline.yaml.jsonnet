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
  editable: false,
  gnetId: null,
  graphTooltip: 0,
  iteration: 1594145734847,
  links: [],
  panels: [
    {
      datasource: null,
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 0,
      },
      id: 8,
      title: 'Shoreline',
      type: 'row',
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
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 9,
        w: 24,
        x: 0,
        y: 1,
      },
      hiddenSeries: false,
      id: 2,
      interval: '',
      legend: {
        alignAsTable: true,
        avg: true,
        current: true,
        hideZero: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        total: true,
        values: true,
      },
      lines: true,
      linewidth: 1,
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
          expr: 'sum(increase(tidepool_shoreline_failed_status_count{namespace="$env"}[5m])) by (status_reason, status_code)',
          interval: '',
          legendFormat: '{{status_reason}} - {{status_code}}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Failed Statuses [5m]',
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
          '$$hashKey': 'object:63',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:64',
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
        y: 10,
      },
      id: 10,
      panels: [],
      title: 'Marketo',
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
              from: '1',
              id: 0,
              op: '=',
              text: 'Yes',
              to: '5000',
              type: 2,
              value: '1',
            },
            {
              id: 1,
              op: '=',
              text: 'No',
              type: 1,
              value: '0',
            },
          ],
          nullValueMode: 'connected',
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: '#299c46',
                value: null,
              },
              {
                color: '#d44a3a',
                value: 0,
              },
              {
                color: 'green',
                value: 1,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 7,
        w: 5,
        x: 0,
        y: 11,
      },
      id: 6,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'background',
        fieldOptions: {
          calcs: [
            'mean',
          ],
        },
        graphMode: 'none',
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
          expr: 'sum(tidepool_shoreline_marketo_config_valid{namespace="$env"}) by (service)',
          instant: true,
          interval: '',
          legendFormat: '{{ service }}',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Is the Marketo configuration valid?',
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
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 7,
        w: 19,
        x: 5,
        y: 11,
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
      pointradius: 2,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'sum(increase(tidepool_shoreline_failed_marketo_upload_total{namespace="$env"}[5m])) by (service)',
          interval: '',
          legendFormat: '{{ service }}',
          refId: 'A',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Failed Uploads to Marketo [5m]',
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
          '$$hashKey': 'object:157',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:158',
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
  refresh: false,
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'tidepool',
    'shoreline',
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
          selected: true,
          text: 'tidepool-prod',
          value: 'tidepool-prod',
        },
        datasource: '$datasource',
        definition: 'label_values(tidepool_shoreline_failed_status_count, namespace)',
        hide: 0,
        includeAll: false,
        label: 'Environment',
        multi: false,
        name: 'env',
        options: [],
        query: 'label_values(tidepool_shoreline_failed_status_count, namespace)',
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
    from: 'now-12h',
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
  title: 'Shoreline',
  uid: '5sv7jfiGk',
  version: 4,
};

local configmap(me) = grafana.dashboard(me, 'tidepool-shoreline', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

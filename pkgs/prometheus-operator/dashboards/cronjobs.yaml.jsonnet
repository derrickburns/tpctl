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
  description: 'Consolidated Dashboard for Monitoring All Batch job pods and Cronjob in Kubernetes',
  editable: false,
  gnetId: 10884,
  graphTooltip: 0,
  id: 366,
  iteration: 1593274389307,
  links: [],
  panels: [
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              from: '',
              id: 0,
              operator: '',
              text: '',
              to: '',
              type: 1,
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
        },
        overrides: [],
      },
      gridPos: {
        h: 4,
        w: 6,
        x: 0,
        y: 0,
      },
      id: 10,
      options: {
        colorMode: 'value',
        graphMode: 'none',
        justifyMode: 'auto',
        orientation: 'auto',
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
          expr: 'sum(kube_cronjob_info{namespace=~"$namespace"})',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Total CronJobs',
      type: 'stat',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              from: '',
              id: 0,
              operator: '',
              text: '',
              to: '',
              type: 1,
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
        },
        overrides: [],
      },
      gridPos: {
        h: 4,
        w: 6,
        x: 6,
        y: 0,
      },
      id: 11,
      options: {
        colorMode: 'value',
        graphMode: 'none',
        justifyMode: 'auto',
        orientation: 'auto',
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
          expr: 'sum(kube_cronjob_status_active{namespace=~"$namespace"})',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Currently Running',
      type: 'stat',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {
            align: null,
          },
          decimals: 0,
          mappings: [
            {
              from: '',
              id: 0,
              operator: '',
              text: '0',
              to: '',
              type: 1,
              value: '',
            },
          ],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: null,
              },
              {
                color: 'green',
                value: 1,
              },
            ],
          },
          unit: 'short',
        },
        overrides: [],
      },
      gridPos: {
        h: 4,
        w: 6,
        x: 12,
        y: 0,
      },
      id: 16,
      options: {
        colorMode: 'value',
        graphMode: 'none',
        justifyMode: 'auto',
        orientation: 'auto',
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
          expr: 'sum(increase(kube_cronjob_status_active{namespace=~"$namespace", cronjob=~"$cronjob"}[1h]))',
          format: 'time_series',
          instant: false,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Jobs that ran the last hour',
      type: 'stat',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
          mappings: [
            {
              from: '',
              id: 0,
              operator: '',
              text: '',
              to: '',
              type: 1,
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
                value: 1,
              },
            ],
          },
        },
        overrides: [],
      },
      gridPos: {
        h: 4,
        w: 6,
        x: 18,
        y: 0,
      },
      id: 14,
      options: {
        colorMode: 'value',
        graphMode: 'none',
        justifyMode: 'auto',
        orientation: 'auto',
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
          expr: 'sum(kube_job_status_failed{namespace=~"$namespace", job_name=~".*$cronjob.*"})',
          format: 'time_series',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Failed Jobs',
      type: 'stat',
    },
    {
      aliasColors: {},
      bars: false,
      cacheTimeout: null,
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
        h: 9,
        w: 12,
        x: 0,
        y: 4,
      },
      hiddenSeries: false,
      id: 12,
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
          expr: 'kube_cronjob_status_active{namespace=~"$namespace", cronjob=~"$cronjob"}',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{  cronjob }}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Cron Job Activity',
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
      cacheTimeout: null,
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
        h: 9,
        w: 12,
        x: 12,
        y: 4,
      },
      hiddenSeries: false,
      id: 17,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        hideEmpty: true,
        hideZero: true,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        sideWidth: null,
        total: false,
        values: false,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null as zero',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 0.5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'kube_job_status_failed{namespace=~"$namespace", job_name=~".*$cronjob.*"}',
          format: 'time_series',
          interval: '',
          intervalFactor: 1,
          legendFormat: '{{ job_name }}',
          refId: 'B',
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Failed Jobs',
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
      cacheTimeout: null,
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
              text: '',
              to: '',
              type: 1,
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
        },
        overrides: [],
      },
      gridPos: {
        h: 11,
        w: 12,
        x: 0,
        y: 13,
      },
      id: 2,
      links: [],
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: false,
            displayName: 'job',
          },
        ],
      },
      pluginVersion: '7.0.3',
      repeat: null,
      repeatDirection: 'h',
      targets: [
        {
          expr: 'kube_cronjob_info{namespace=~"$namespace"}',
          format: 'table',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Cron Jobs in $namespace',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              __name__: true,
              endpoint: true,
              instance: true,
              job: true,
              namespace: true,
              pod: true,
              service: true,
            },
            indexByName: {},
            renameByName: {
              __name__: '',
            },
          },
        },
      ],
      type: 'table',
    },
    {
      cacheTimeout: null,
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
              text: '',
              to: '',
              type: 1,
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
          unit: 'dateTimeFromNow',
        },
        overrides: [],
      },
      gridPos: {
        h: 11,
        w: 12,
        x: 12,
        y: 13,
      },
      id: 13,
      links: [],
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: false,
            displayName: 'Value',
          },
        ],
      },
      pluginVersion: '7.0.3',
      repeatDirection: 'h',
      targets: [
        {
          expr: 'kube_cronjob_next_schedule_time{namespace=~"$namespace"} * 1000',
          format: 'table',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Upcoming Jobs in $namespace',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              __name__: true,
              endpoint: true,
              instance: true,
              job: true,
              namespace: true,
              pod: true,
              service: true,
            },
            indexByName: {},
            renameByName: {
              Value: '',
              __name__: '',
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
  tags: [],
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
          text: 'qa',
          value: 'qa',
        },
        datasource: '$datasource',
        definition: 'label_values(kube_cronjob_info, namespace)',
        hide: 0,
        includeAll: false,
        label: 'Namespace',
        multi: false,
        name: 'namespace',
        options: [],
        query: 'label_values(kube_cronjob_info, namespace)',
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
          text: 'k6-default-dev1',
          value: 'k6-default-dev1',
        },
        datasource: '$datasource',
        definition: 'label_values(kube_cronjob_info{namespace=~"$namespace"}, cronjob)',
        hide: 0,
        includeAll: false,
        label: 'Cron Job',
        multi: false,
        name: 'cronjob',
        options: [],
        query: 'label_values(kube_cronjob_info{namespace=~"$namespace"}, cronjob)',
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
    from: 'now-24h',
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
  timezone: '',
  title: 'Kubernetes / Jobs / Cron Jobs',
  uid: 'cb0HhItWz',
  version: 10,
};

local configmap(me) = grafana.dashboard(me, 'kubernetes-jobs', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

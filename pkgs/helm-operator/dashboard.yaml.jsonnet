local common = import '../../lib/common.jsonnet';
local grafana = import '../../lib/grafana.jsonnet';

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
  iteration: 1602628464017,
  links: [],
  panels: [
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
                color: '#d44a3a',
                value: null,
              },
              {
                color: 'rgba(237, 129, 40, 0.89)',
                value: 0,
              },
              {
                color: '#299c46',
                value: 0,
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
        y: 0,
      },
      id: 2,
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
        textMode: 'auto',
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'flux_helm_operator_release_count',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Charts Deployed',
      type: 'stat',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {
            align: null,
            displayMode: 'auto',
            filterable: false,
          },
          mappings: [],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
            ],
          },
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Status',
            },
            properties: [
              {
                id: 'custom.displayMode',
                value: 'color-background',
              },
              {
                id: 'thresholds',
                value: {
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
              },
            ],
          },
        ],
      },
      gridPos: {
        h: 9,
        w: 18,
        x: 6,
        y: 0,
      },
      id: 4,
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: false,
            displayName: 'Status',
          },
        ],
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'flux_helm_operator_release_condition_info{condition="Released"}',
          format: 'table',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Released Charts',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: false,
              __name__: true,
              condition: true,
              endpoint: true,
              instance: true,
              job: true,
              namespace: true,
              pod: true,
              service: true,
            },
            indexByName: {},
            renameByName: {
              Value: 'Status',
              release_name: 'Release name',
              service: 'Service',
              target_namespace: 'Target namespace',
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
                color: '#299c46',
                value: null,
              },
              {
                color: 'rgba(237, 129, 40, 0.89)',
                value: 5,
              },
              {
                color: '#d44a3a',
                value: 6,
              },
            ],
          },
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 6,
        w: 6,
        x: 0,
        y: 5,
      },
      id: 7,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
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
        textMode: 'auto',
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'flux_helm_operator_release_queue_length_count',
          instant: true,
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Releases in Queue',
      type: 'stat',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {
            align: null,
            displayMode: 'auto',
            filterable: false,
          },
          mappings: [],
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
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Status',
            },
            properties: [
              {
                id: 'custom.displayMode',
                value: 'color-background',
              },
              {
                id: 'thresholds',
                value: {
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
              },
            ],
          },
        ],
      },
      gridPos: {
        h: 9,
        w: 18,
        x: 6,
        y: 9,
      },
      id: 10,
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: false,
            displayName: 'Status',
          },
        ],
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'flux_helm_operator_release_condition_info{condition="ChartFetched"}',
          format: 'table',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Fetched Charts',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: false,
              __name__: true,
              condition: true,
              endpoint: true,
              instance: true,
              job: true,
              namespace: true,
              pod: true,
              service: true,
            },
            indexByName: {},
            renameByName: {
              Value: 'Status',
              release_name: 'Release name',
              service: 'Service',
              target_namespace: 'Target namespace',
            },
          },
        },
      ],
      type: 'table',
    },
    {
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {
            align: null,
            displayMode: 'auto',
            filterable: false,
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
                value: 1,
              },
            ],
          },
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Status',
            },
            properties: [],
          },
        ],
      },
      gridPos: {
        h: 9,
        w: 18,
        x: 6,
        y: 18,
      },
      id: 11,
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: true,
            displayName: 'Status',
          },
        ],
      },
      pluginVersion: '7.2.0',
      targets: [
        {
          expr: 'flux_helm_operator_release_condition_info{condition="RolledBack"}',
          format: 'table',
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Rolled Back Charts',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: false,
              __name__: true,
              condition: true,
              endpoint: true,
              instance: true,
              job: true,
              namespace: true,
              pod: true,
              service: true,
            },
            indexByName: {},
            renameByName: {
              Value: 'Status',
              release_name: 'Release name',
              service: 'Service',
              target_namespace: 'Target namespace',
            },
          },
        },
      ],
      type: 'table',
    },
  ],
  schemaVersion: 26,
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
  title: 'Helm Operator',
  uid: 'c8qWijkGz',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, me.pkg, dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

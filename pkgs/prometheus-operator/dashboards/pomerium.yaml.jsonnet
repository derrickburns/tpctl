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
  graphTooltip: 0,
  links: [],
  panels: [
    {
      cacheTimeout: null,
      datasource: '$datasource',
      description: '',
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
        w: 6,
        x: 0,
        y: 0,
      },
      id: 3,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'first',
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
          expr: 'pomerium_policy_count_total',
          format: 'table',
          instant: true,
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Pomerium Policies',
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
        h: 7,
        w: 12,
        x: 6,
        y: 0,
      },
      id: 2,
      options: {
        showHeader: true,
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          expr: 'pomerium_build_info',
          format: 'table',
          instant: true,
          refId: 'A',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Pomerium Version',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              Value: true,
              __name__: true,
              endpoint: true,
              goversion: true,
              instance: true,
              job: true,
              pod: true,
              revision: true,
              service: true,
            },
            indexByName: {
              Time: 0,
              Value: 12,
              __name__: 1,
              endpoint: 2,
              exported_service: 7,
              goversion: 3,
              instance: 4,
              job: 5,
              namespace: 6,
              pod: 8,
              revision: 9,
              service: 10,
              version: 11,
            },
            renameByName: {
              Value: '',
              exported_service: 'Service',
              namespace: 'Namespace',
              version: 'Version',
            },
          },
        },
      ],
      type: 'table',
    },
  ],
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'pomerium',
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
  timezone: 'utc',
  title: 'Pomerium',
  uid: '00i1GtmGz',
  version: 1,
};

local configmap(me) = grafana.dashboard(me, 'pomerium', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

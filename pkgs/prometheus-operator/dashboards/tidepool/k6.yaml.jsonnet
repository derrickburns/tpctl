local common = import '../../../../lib/common.jsonnet';
local global = import '../../../../lib/global.jsonnet';
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
  description: 'K6 Testing Dashboard',
  editable: false,
  gnetId: 11614,
  graphTooltip: 0,
  iteration: 1594227723412,
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
      id: 42,
      panels: [],
      title: 'Overview',
      type: 'row',
    },
    {
      aliasColors: {},
      bars: true,
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
        h: 8,
        w: 6,
        x: 0,
        y: 1,
      },
      hiddenSeries: false,
      id: 38,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        max: true,
        min: true,
        rightSide: false,
        show: true,
        total: false,
        values: true,
      },
      lines: false,
      linewidth: 1,
      nullPointMode: 'null as zero',
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
          alias: 'Virtual Users',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: 'vus',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
        {
          alias: 'Virtual Users Max',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: 'vus_max',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'B',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Virtual Users',
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
          '$$hashKey': 'object:305',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:306',
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
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 8,
        w: 6,
        x: 6,
        y: 1,
      },
      hiddenSeries: false,
      id: 46,
      interval: '1s',
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: true,
        min: false,
        rightSide: false,
        show: true,
        total: false,
        values: true,
      },
      lines: true,
      linewidth: 1,
      links: [],
      nullPointMode: 'null as zero',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 1,
      points: false,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          alias: 'Requests per Second',
          dsType: 'influxdb',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: 'http_reqs',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'sum',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Requests per Second',
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
          '$$hashKey': 'object:2527',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: '0',
          show: true,
        },
        {
          '$$hashKey': 'object:2528',
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
            displayMode: 'color-background',
          },
          decimals: 2,
          mappings: [],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: null,
              },
              {
                color: '#EAB839',
                value: 0.9,
              },
              {
                color: 'green',
                value: 0.9999,
              },
            ],
          },
          unit: 'percentunit',
        },
        overrides: [],
      },
      gridPos: {
        h: 8,
        w: 12,
        x: 12,
        y: 1,
      },
      id: 48,
      options: {
        showHeader: true,
        sortBy: [
          {
            desc: false,
            displayName: 'Pass (%)',
          },
        ],
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          groupBy: [
            {
              params: [
                'group',
              ],
              type: 'tag',
            },
            {
              params: [
                'check',
              ],
              type: 'tag',
            },
          ],
          measurement: 'checks',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'table',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Checks',
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
            },
            indexByName: {},
            renameByName: {
              check: 'Check',
              group: 'Action',
              mean: 'Pass (%)',
            },
          },
        },
      ],
      type: 'table',
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
        h: 8,
        w: 6,
        x: 0,
        y: 9,
      },
      hiddenSeries: false,
      id: 53,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        max: true,
        min: false,
        rightSide: false,
        show: true,
        total: true,
        values: true,
      },
      lines: true,
      linewidth: 1,
      nullPointMode: 'null as zero',
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
          alias: 'Iteration',
          groupBy: [
            {
              params: [
                '1m',
              ],
              type: 'time',
            },
          ],
          measurement: 'iterations',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'sum',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Iterations',
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
          '$$hashKey': 'object:2062',
          format: 'short',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:2063',
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
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 8,
        w: 6,
        x: 6,
        y: 9,
      },
      hiddenSeries: false,
      id: 55,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
        max: true,
        min: false,
        rightSide: false,
        show: true,
        total: true,
        values: true,
      },
      lines: true,
      linewidth: 1,
      nullPointMode: 'null as zero',
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
          alias: 'Iteration',
          groupBy: [
            {
              params: [
                '1m',
              ],
              type: 'time',
            },
          ],
          measurement: 'iteration_duration',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Iteration Duration (mean)',
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
          '$$hashKey': 'object:1950',
          format: 'ms',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1951',
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
      bars: true,
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
        h: 8,
        w: 12,
        x: 12,
        y: 9,
      },
      hiddenSeries: false,
      id: 50,
      interval: '>1s',
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        max: false,
        min: false,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: true,
        values: true,
      },
      lines: false,
      linewidth: 1,
      links: [],
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [
        {
          '$$hashKey': 'object:2189',
          alias: 'Num Errors',
          color: '#BF1B00',
        },
      ],
      spaceLength: 10,
      stack: true,
      steppedLine: false,
      targets: [
        {
          alias: '$tag_check',
          dsType: 'influxdb',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'check',
              ],
              type: 'tag',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: 'checks',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'C',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'sum',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: 'Checks Per Second',
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
          '$$hashKey': 'object:2196',
          format: 'none',
          label: null,
          logBase: 1,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:2197',
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
      datasource: '$datasource',
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 17,
      },
      id: 14,
      panels: [],
      title: '$measurement',
      type: 'row',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'ms',
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 4,
        x: 0,
        y: 18,
      },
      id: 8,
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
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          query: "SELECT mean(\"value\") FROM \"http_req_duration\" WHERE (\"group\" = '::scoreboard-main') AND $timeFilter GROUP BY time($__interval) fill(null)",
          rawQuery: false,
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
            {
              condition: 'AND',
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: '$measurement (mean)',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'ms',
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 4,
        x: 4,
        y: 18,
      },
      id: 12,
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
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'median',
              },
            ],
          ],
          tags: [
            {
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
            {
              condition: 'AND',
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: '$measurement (median)',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'ms',
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 4,
        x: 8,
        y: 18,
      },
      id: 10,
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
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'min',
              },
            ],
          ],
          tags: [
            {
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: '$measurement (min)',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'ms',
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 4,
        x: 12,
        y: 18,
      },
      id: 16,
      interval: null,
      links: [],
      maxDataPoints: 100,
      options: {
        colorMode: 'value',
        fieldOptions: {
          calcs: [
            'max',
          ],
        },
        graphMode: 'none',
        justifyMode: 'auto',
        orientation: 'horizontal',
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
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'max',
              },
            ],
          ],
          tags: [
            {
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
            {
              condition: 'AND',
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: '$measurement (max)',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'ms',
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 4,
        x: 16,
        y: 18,
      },
      id: 18,
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
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [
                  '90',
                ],
                type: 'percentile',
              },
            ],
          ],
          tags: [
            {
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
            {
              condition: 'AND',
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: '$measurement (p90)',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'ms',
        },
        overrides: [],
      },
      gridPos: {
        h: 3,
        w: 4,
        x: 20,
        y: 18,
      },
      id: 20,
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
            'mean',
          ],
          fields: '',
          values: false,
        },
      },
      pluginVersion: '7.0.3',
      targets: [
        {
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'null',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [
                  '95',
                ],
                type: 'percentile',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: '$measurement (p95)',
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
        h: 9,
        w: 12,
        x: 0,
        y: 21,
      },
      hiddenSeries: false,
      id: 6,
      interval: '>1s',
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
      nullPointMode: 'null as zero',
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
          alias: 'p95',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          query: 'SELECT max("value") FROM /^$Measurement$/ WHERE $timeFilter and value > 0 GROUP BY time($__interval) fill(none)\n',
          rawQuery: false,
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [
                  '95',
                ],
                type: 'percentile',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
        {
          alias: 'p90',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          query: 'SELECT percentile("value", 95) FROM /^$Measurement$/ WHERE $timeFilter and value > 0 GROUP BY time($__interval) fill(none)',
          rawQuery: false,
          refId: 'B',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [
                  '90',
                ],
                type: 'percentile',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
        {
          alias: 'max',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          query: 'SELECT percentile("value", 90) FROM /^$Measurement$/ WHERE $timeFilter and value > 0 GROUP BY time($__interval) fill(none)',
          rawQuery: false,
          refId: 'C',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'max',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
        {
          alias: 'min',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          query: 'SELECT min("value") FROM /^$Measurement$/ WHERE $timeFilter and value > 0 GROUP BY time($__interval) fill(none)',
          rawQuery: false,
          refId: 'D',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'min',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '$measurement (over time)',
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
          '$$hashKey': 'object:608',
          format: 'ms',
          label: 'Time (s)',
          logBase: 2,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:609',
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
      cards: {
        cardPadding: null,
        cardRound: null,
      },
      color: {
        cardColor: 'rgb(0, 234, 255)',
        colorScale: 'sqrt',
        colorScheme: 'interpolateYlOrRd',
        exponent: 0.5,
        mode: 'spectrum',
      },
      dataFormat: 'timeseries',
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      gridPos: {
        h: 9,
        w: 12,
        x: 12,
        y: 21,
      },
      heatmap: {},
      height: '250px',
      hideZeroBuckets: false,
      highlightCards: true,
      id: 52,
      interval: '>1s',
      legend: {
        show: false,
      },
      links: [],
      reverseYBuckets: false,
      targets: [
        {
          dsType: 'influxdb',
          groupBy: [],
          hide: false,
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'B',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
            ],
          ],
          tags: [
            {
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
            {
              condition: 'AND',
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
          ],
        },
      ],
      title: '$measurement (over time)',
      tooltip: {
        show: true,
        showHistogram: true,
      },
      tooltipDecimals: null,
      type: 'heatmap',
      xAxis: {
        show: true,
      },
      xBucketNumber: null,
      xBucketSize: null,
      yAxis: {
        decimals: null,
        format: 'ms',
        logBase: 2,
        max: null,
        min: null,
        show: true,
        splitFactor: null,
      },
      yBucketBound: 'auto',
      yBucketNumber: null,
      yBucketSize: null,
    },
    {
      aliasColors: {},
      bars: true,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      description: '',
      fieldConfig: {
        defaults: {
          custom: {},
        },
        overrides: [],
      },
      fill: 1,
      fillGradient: 0,
      gridPos: {
        h: 8,
        w: 24,
        x: 0,
        y: 30,
      },
      hiddenSeries: false,
      id: 44,
      interval: '>1s',
      legend: {
        alignAsTable: true,
        avg: true,
        current: false,
        hideEmpty: true,
        hideZero: true,
        max: true,
        min: true,
        rightSide: true,
        show: true,
        sort: 'avg',
        sortDesc: true,
        total: false,
        values: true,
      },
      lines: false,
      linewidth: 1,
      nullPointMode: 'null',
      options: {
        dataLinks: [],
      },
      percentage: false,
      pointradius: 1,
      points: true,
      renderer: 'flot',
      seriesOverrides: [],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          alias: '$tag_group',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'group',
              ],
              type: 'tag',
            },
          ],
          measurement: '/^$measurement$/',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'value',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'group',
              operator: '=~',
              value: '/^$groups$/',
            },
            {
              condition: 'AND',
              key: 'env',
              operator: '=~',
              value: '/^$env$/',
            },
          ],
        },
      ],
      thresholds: [],
      timeFrom: null,
      timeRegions: [],
      timeShift: null,
      title: '$measurement',
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
          '$$hashKey': 'object:1082',
          format: 'ms',
          label: null,
          logBase: 2,
          max: null,
          min: null,
          show: true,
        },
        {
          '$$hashKey': 'object:1083',
          format: 'ms',
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
    'tests',
    'qa',
  ],
  templating: {
    list: [
      {
        allValue: null,
        current: {
          selected: true,
          text: 'http_req_duration',
          value: 'http_req_duration',
        },
        hide: 0,
        includeAll: false,
        label: 'Measurement',
        multi: false,
        name: 'measurement',
        options: [
          {
            selected: true,
            text: 'http_req_duration',
            value: 'http_req_duration',
          },
          {
            selected: false,
            text: 'http_req_blocked',
            value: 'http_req_blocked',
          },
          {
            selected: false,
            text: 'http_req_connecting',
            value: 'http_req_connecting',
          },
          {
            selected: false,
            text: 'http_req_looking_up',
            value: 'http_req_looking_up',
          },
          {
            selected: false,
            text: 'http_req_receiving',
            value: 'http_req_receiving',
          },
          {
            selected: false,
            text: 'http_req_sending',
            value: 'http_req_sending',
          },
          {
            selected: false,
            text: 'http_req_waiting',
            value: 'http_req_waiting',
          },
        ],
        query: 'http_req_duration,http_req_blocked,http_req_connecting,http_req_looking_up,http_req_receiving,http_req_sending,http_req_waiting',
        queryValue: '',
        skipUrlSync: false,
        type: 'custom',
      },
      {
        allValue: null,
        current: {
          selected: true,
          text: 'All',
          value: [
            '$__all',
          ],
        },
        datasource: '$datasource',
        definition: 'SHOW TAG VALUES WITH KEY = "group"',
        hide: 0,
        includeAll: true,
        label: 'Groups',
        multi: true,
        name: 'groups',
        options: [],
        query: 'SHOW TAG VALUES WITH KEY = "group"',
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
          text: 'dev1',
          value: 'dev1',
        },
        datasource: '$datasource',
        definition: 'SHOW TAG VALUES WITH KEY = "env"',
        hide: 0,
        includeAll: false,
        label: 'Env',
        multi: false,
        name: 'env',
        options: [],
        query: 'SHOW TAG VALUES WITH KEY = "env"',
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
        current: {
          selected: false,
          text: 'InfluxDB',
          value: 'InfluxDB',
        },
        hide: 2,
        includeAll: false,
        label: 'Datasource',
        multi: false,
        name: 'datasource',
        options: [],
        query: 'influxdb',
        refresh: 1,
        regex: '',
        skipUrlSync: false,
        type: 'datasource',
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
  timezone: '',
  title: 'QA / Tests / Loadtest / K6',
  uid: 'Bz167sD',
  version: 2,
};

local configmap(me) = grafana.dashboard(me, 'k6', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name == 'shared'
  then [
    configmap(me),
  ]
  else {}
)

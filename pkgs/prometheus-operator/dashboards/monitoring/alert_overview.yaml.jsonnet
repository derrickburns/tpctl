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
      {
        datasource: '$datasource',
        enable: false,
        expr: 'ALERTS_FOR_STATE{service=~"$service", alertname=~"$alertname"} * 1000',
        hide: false,
        iconColor: '#37872D',
        limit: 100,
        name: 'Alerts annotations:',
        showIn: 0,
        step: '2s',
        tagKeys: 'alertname',
        tags: [

        ],
        textFormat: '',
        titleFormat: '{{service}}',
        type: 'tags',
        useValueForTime: true,
      },
      {
        datasource: '-- Grafana --',
        enable: true,
        hide: true,
        iconColor: 'rgba(255, 96, 96, 1)',
        limit: 100,
        name: 'Display comments',
        showIn: 0,
        tags: [
          'note',
        ],
        type: 'tags',
      },
    ],
  },
  description: 'Dashboard showing Prometheus Alerts (both pending and firing) for alerts adjustment and debugging',
  editable: false,
  gnetId: 11098,
  graphTooltip: 1,
  id: 205,
  iteration: 1592482567730,
  links: [
    {
      icon: 'external link',
      includeVars: true,
      keepTime: true,
      tags: [
        'OS',
      ],
      type: 'dashboards',
    },
    {
      icon: 'external link',
      tags: [
        'alerts-advanced',
      ],
      type: 'dashboards',
    },
  ],
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
      id: 443,
      panels: [

      ],
      title: 'Severity',
      type: 'row',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
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
        h: 4,
        w: 5,
        x: 0,
        y: 1,
      },
      height: '75px',
      id: 4,
      interval: null,
      links: [

      ],
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
          expr: 'sum(ALERTS{alertname=~"$alertname",alertstate=~"$alertstate"})',
          format: 'time_series',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '1',
      title: 'Alerts',
      type: 'singlestat',
      valueFontSize: '80%',
      valueMaps: [
        {
          op: '=',
          text: '0',
          value: 'null',
        },
      ],
      valueName: 'avg',
    },
    {
      cacheTimeout: null,
      colorBackground: true,
      colorValue: false,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
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
        h: 4,
        w: 5,
        x: 5,
        y: 1,
      },
      height: '75px',
      id: 2,
      interval: null,
      links: [

      ],
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
          bucketAggs: [
            {
              id: '2',
              settings: {
                interval: 'auto',
                min_doc_count: 0,
                trimEdges: 0,
              },
              type: 'date_histogram',
            },
          ],
          dsType: 'elasticsearch',
          expr: 'sum(ALERTS{alertname=~"$alertname",alertstate="firing", severity="critical"})',
          format: 'time_series',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          metrics: [
            {
              field: 'select field',
              id: '1',
              type: 'count',
            },
          ],
          refId: 'A',
        },
      ],
      thresholds: '1,1',
      title: 'Critical',
      type: 'singlestat',
      valueFontSize: '100%',
      valueMaps: [
        {
          op: '=',
          text: '0',
          value: 'null',
        },
      ],
      valueName: 'avg',
    },
    {
      cacheTimeout: null,
      colorBackground: true,
      colorValue: false,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
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
        h: 4,
        w: 5,
        x: 10,
        y: 1,
      },
      height: '75px',
      id: 5,
      interval: null,
      links: [

      ],
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
          expr: 'sum(ALERTS{alertname=~"$alertname",alertstate=~"$alertstate",severity="warning"})',
          format: 'time_series',
          instant: true,
          interval: '',
          intervalFactor: 2,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '1,5',
      title: 'Warning',
      type: 'singlestat',
      valueFontSize: '100%',
      valueMaps: [
        {
          op: '=',
          text: 'N/A',
          value: 'null',
        },
      ],
      valueName: 'avg',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
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
        h: 4,
        w: 5,
        x: 15,
        y: 1,
      },
      height: '75px',
      id: 9,
      interval: null,
      links: [

      ],
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
          expr: 'sum(ALERTS{service=~"$service",alertname=~"$alertname",alertstate=~"$alertstate",severity="info"})',
          format: 'time_series',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '1',
      title: 'Info',
      type: 'singlestat',
      valueFontSize: '100%',
      valueMaps: [
        {
          op: '=',
          text: '0',
          value: 'null',
        },
      ],
      valueName: 'avg',
    },
    {
      cacheTimeout: null,
      colorBackground: false,
      colorValue: true,
      colors: [
        '#299c46',
        'rgba(237, 129, 40, 0.89)',
        '#d44a3a',
      ],
      datasource: '$datasource',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
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
        h: 4,
        w: 4,
        x: 20,
        y: 1,
      },
      height: '75px',
      id: 441,
      interval: null,
      links: [

      ],
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
          expr: 'sum(ALERTS{alertname=~"$alertname",alertstate=~"$alertstate",severity="none"})',
          format: 'time_series',
          instant: true,
          interval: '',
          intervalFactor: 1,
          legendFormat: '',
          refId: 'A',
        },
      ],
      thresholds: '1',
      title: 'None',
      type: 'singlestat',
      valueFontSize: '100%',
      valueMaps: [
        {
          op: '=',
          text: '0',
          value: 'null',
        },
      ],
      valueName: 'avg',
    },
    {
      collapsed: false,
      datasource: '$datasource',
      gridPos: {
        h: 1,
        w: 24,
        x: 0,
        y: 5,
      },
      id: 445,
      panels: [

      ],
      title: 'Alerts',
      type: 'row',
    },
    {
      columns: [

      ],
      datasource: '$datasource',
      description: 'Shows how many times was particular alert started in a defined time range. Alert can be started either directly as `firing` or as a `pending`. Pending alerts wait for a defined time before it flips to a `firing` alert. This is specified with the `FOR` clause in a Prometheus `rules` file.',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
      },
      fontSize: '100%',
      gridPos: {
        h: 13,
        w: 24,
        x: 0,
        y: 6,
      },
      id: 414,
      pageSize: null,
      showHeader: true,
      sort: {
        col: 10,
        desc: true,
      },
      styles: [
        {
          alias: 'Time',
          align: 'auto',
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          link: false,
          pattern: 'Time',
          type: 'hidden',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'instance',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'Value',
          thresholds: [

          ],
          type: 'number',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'pod',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'namespace',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'service',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'endpoint',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: '__name__',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          dateFormat: 'YYYY-MM-DD HH:mm:ss',
          decimals: 2,
          mappingType: 1,
          pattern: 'job',
          thresholds: [

          ],
          type: 'hidden',
          unit: 'short',
        },
        {
          alias: '',
          align: 'auto',
          colorMode: null,
          colors: [
            'rgba(245, 54, 54, 0.9)',
            'rgba(237, 129, 40, 0.89)',
            'rgba(50, 172, 45, 0.97)',
          ],
          decimals: 2,
          pattern: '/.*/',
          thresholds: [

          ],
          type: 'string',
          unit: 'short',
        },
      ],
      targets: [
        {
          expr: 'ALERTS{alertname=~"$alertname", alertstate=~"$alertstate"}',
          format: 'table',
          hide: false,
          instant: true,
          interval: '',
          legendFormat: '',
          refId: 'B',
        },
      ],
      timeFrom: null,
      timeShift: null,
      title: 'Total Alert Counts',
      transform: 'table',
      type: 'table-old',
    },
    {
      aliasColors: {

      },
      bars: false,
      dashLength: 10,
      dashes: false,
      datasource: '$datasource',
      description: '',
      fieldConfig: {
        defaults: {
          custom: {

          },
        },
        overrides: [

        ],
      },
      fill: 0,
      fillGradient: 10,
      gridPos: {
        h: 9,
        w: 24,
        x: 0,
        y: 19,
      },
      hiddenSeries: false,
      id: 440,
      legend: {
        alignAsTable: true,
        avg: false,
        current: false,
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
      nullPointMode: 'null as zero',
      options: {
        dataLinks: [

        ],
      },
      percentage: false,
      pointradius: 0.5,
      points: false,
      renderer: 'flot',
      seriesOverrides: [
        {
          alias: '',
        },
      ],
      spaceLength: 10,
      stack: false,
      steppedLine: false,
      targets: [
        {
          expr: 'ALERTS{alertname=~"$alertname", alertstate=~"$alertstate"}',
          instant: false,
          interval: '',
          legendFormat: '{{ alertname }} | {{ alertstate }} | {{ container }} | {{ namespace }} | {{ name }} | {{ severity }}',
          refId: 'C',
        },
      ],
      thresholds: [

      ],
      timeFrom: null,
      timeRegions: [

      ],
      timeShift: null,
      title: 'Alerts History',
      tooltip: {
        shared: true,
        sort: 0,
        value_type: 'cumulative',
      },
      type: 'graph',
      xaxis: {
        buckets: null,
        mode: 'time',
        name: null,
        show: true,
        values: [

        ],
      },
      yaxes: [
        {
          decimals: null,
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
          max: '1',
          min: '-1',
          show: false,
        },
      ],
      yaxis: {
        align: true,
        alignLevel: 0,
      },
    },
  ],
  refresh: false,
  schemaVersion: 25,
  style: 'dark',
  tags: [
    'prometheus',
    'alerts',
  ],
  templating: {
    list: [
      {
        current: {
          selected: false,
          text: 'default',
          value: 'default',
        },
        hide: 2,
        includeAll: false,
        label: 'Prometheus datasource',
        multi: false,
        name: 'datasource',
        options: [

        ],
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
          tags: [

          ],
          text: 'All',
          value: [
            '$__all',
          ],
        },
        datasource: '$datasource',
        definition: 'label_values(ALERTS_FOR_STATE,alertname)',
        hide: 0,
        includeAll: true,
        label: 'Alert:',
        multi: true,
        name: 'alertname',
        options: [

        ],
        query: 'label_values(ALERTS_FOR_STATE,alertname)',
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [

        ],
        tagsQuery: '',
        type: 'query',
        useTags: false,
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
        definition: 'label_values(ALERTS, alertstate)',
        hide: 0,
        includeAll: true,
        label: 'State:',
        multi: true,
        name: 'alertstate',
        options: [

        ],
        query: 'label_values(ALERTS, alertstate)',
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [

        ],
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
  title: 'Alertmanager / Alerts / Overview',
  uid: 'lcaKO4WGk',
  version: 4,
};

local configmap(me) = grafana.dashboard(me, 'alerts-overview', dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

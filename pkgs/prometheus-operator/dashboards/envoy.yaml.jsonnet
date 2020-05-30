local common = import '../../../lib/common.jsonnet';
local k8s = import '../../../lib/k8s.jsonnet';
local lib = import '../../../lib/lib.jsonnet';

local dashboardName = 'envoy';
local configmapName = '%s-dashboard' % dashboardName;

local configmap(me) = k8s.configmap(me, configmapName) {
  metadata+: {
    labels: {
      grafana_dashboard: configmapName,
    },
  },
  data: {
    'dashboard.json': std.manifestJsonEx(
      {
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
        id: 2,
        links: [],
        panels: [
          {
            aliasColors: {},
            bars: false,
            dashLength: 10,
            dashes: false,
            datasource: null,
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 0,
              y: 0,
            },
            hiddenSeries: false,
            id: 14,
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
            links: [],
            nullPointMode: 'null',
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
                expr: 'sum(irate(envoy_http_downstream_rq_total[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'requests',
                refId: 'A',
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
            aliasColors: {
              '% 2xx': '#7eb26d',
              '% 4xx': '#eab839',
              '% 5xx': '#bf1b00',
            },
            bars: false,
            dashLength: 10,
            dashes: false,
            datasource: null,
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 12,
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
            links: [],
            nullPointMode: 'null',
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
                expr: 'sum(irate(envoy_http_downstream_rq_xx{envoy_response_code_class="2"}[1m])) / sum(irate(envoy_http_downstream_rq_total[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: '% 2xx',
                refId: 'B',
              },
              {
                expr: 'sum(irate(envoy_http_downstream_rq_xx{envoy_response_code_class="4"}[1m])) / sum(irate(envoy_http_downstream_rq_total[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: '% 4xx',
                refId: 'C',
              },
              {
                expr: 'sum(irate(envoy_http_downstream_rq_xx{envoy_response_code_class="5"}[1m])) / sum(irate(envoy_http_downstream_rq_total[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: '% 5xx',
                refId: 'A',
              },
            ],
            thresholds: [],
            timeFrom: null,
            timeRegions: [],
            timeShift: null,
            title: 'Percent Response Code per Second',
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
            aliasColors: {
              '2xx': '#7eb26d',
              '4xx': '#eab839',
              '5xx': '#bf1b00',
            },
            bars: false,
            dashLength: 10,
            dashes: false,
            datasource: 'Prometheus',
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 0,
              y: 9,
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
            links: [],
            nullPointMode: 'null',
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
                expr: 'sum(irate(envoy_http_downstream_rq_xx{envoy_response_code_class="2"}[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: '2xx',
                refId: 'A',
              },
              {
                expr: 'sum(irate(envoy_http_downstream_rq_xx{envoy_response_code_class="4"}[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: '4xx',
                refId: 'B',
              },
              {
                expr: 'sum(irate(envoy_http_downstream_rq_xx{envoy_response_code_class="5"}[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: '5xx',
                refId: 'C',
              },
            ],
            thresholds: [],
            timeFrom: null,
            timeRegions: [],
            timeShift: null,
            title: 'Response Codes per Second',
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
            dashLength: 10,
            dashes: false,
            datasource: 'Prometheus',
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 12,
              y: 9,
            },
            hiddenSeries: false,
            id: 12,
            legend: {
              alignAsTable: true,
              avg: true,
              current: false,
              max: true,
              min: true,
              rightSide: false,
              show: true,
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
            pointradius: 5,
            points: false,
            renderer: 'flot',
            seriesOverrides: [],
            spaceLength: 10,
            stack: false,
            steppedLine: false,
            targets: [
              {
                expr: 'sum(rate(envoy_cluster_upstream_rq_time_sum{envoy_cluster_name=~".*_Prometheus-system",envoy_cluster_name!~"kube*|Prometheus*"}[1m])) / sum(rate(envoy_cluster_upstream_rq_time_count{envoy_cluster_name=~".*_Prometheus-system",envoy_cluster_name!~"kube*|Prometheus*"}[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'average time to upstream',
                refId: 'A',
              },
              {
                expr: 'sum(rate(envoy_http_downstream_rq_time_sum{envoy_http_conn_manager_prefix!~"admin|prometheus|async-client"}[1m])) / sum(rate(envoy_http_downstream_rq_time_count{envoy_http_conn_manager_prefix!~"(admin|prometheus|async-client)"}[1m]))',
                format: 'time_series',
                hide: false,
                intervalFactor: 1,
                legendFormat: 'average time from downstream',
                refId: 'B',
              },
            ],
            thresholds: [],
            timeFrom: null,
            timeRegions: [],
            timeShift: null,
            title: 'Average Request Time',
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
                format: 'ms',
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
                show: true,
              },
            ],
            yaxis: {
              align: false,
              alignLevel: null,
            },
          },
          {
            aliasColors: {
              P90: '#7eb26d',
              P95: '#eab839',
              P99: '#6ed0e0',
              'upstream p95': '#f4d598',
              'upstream p99': '#e5a8e2',
            },
            bars: false,
            dashLength: 10,
            dashes: false,
            datasource: null,
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 0,
              y: 18,
            },
            hiddenSeries: false,
            id: 16,
            legend: {
              alignAsTable: false,
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
            links: [],
            nullPointMode: 'null',
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
                expr: 'histogram_quantile(0.90, sum(rate(envoy_cluster_upstream_rq_time_bucket[1m])) by (le))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'P90',
                refId: 'C',
              },
              {
                expr: 'histogram_quantile(0.95, sum(rate(envoy_cluster_upstream_rq_time_bucket[1m])) by (le))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'P95',
                refId: 'A',
              },
              {
                expr: 'histogram_quantile(0.99, sum(rate(envoy_cluster_upstream_rq_time_bucket[1m])) by (le))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'P99',
                refId: 'B',
              },
            ],
            thresholds: [],
            timeFrom: null,
            timeRegions: [],
            timeShift: null,
            title: 'Upstream Request Time Percentiles',
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
                format: 'ms',
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
            aliasColors: {
              P90: '#7eb26d',
              P95: '#eab839',
              P99: '#6ed0e0',
            },
            bars: false,
            dashLength: 10,
            dashes: false,
            datasource: null,
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 12,
              y: 18,
            },
            hiddenSeries: false,
            id: 18,
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
            links: [],
            nullPointMode: 'null',
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
                expr: 'histogram_quantile(0.90, sum(rate(envoy_http_downstream_rq_time_bucket[1m])) by (le))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'P90',
                refId: 'A',
              },
              {
                expr: 'histogram_quantile(0.95, sum(rate(envoy_http_downstream_rq_time_bucket[1m])) by (le))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'P95',
                refId: 'B',
              },
              {
                expr: 'histogram_quantile(0.99, sum(rate(envoy_http_downstream_rq_time_bucket[1m])) by (le))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'P99',
                refId: 'C',
              },
            ],
            thresholds: [],
            timeFrom: null,
            timeRegions: [],
            timeShift: null,
            title: 'Round Trip Time Percentiles',
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
                format: 'ms',
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
            aliasColors: {
              Denied: '#eab839',
              Error: '#bf1b00',
              OK: '#7eb26d',
              Total: '#6ed0e0',
            },
            bars: false,
            dashLength: 10,
            dashes: false,
            datasource: null,
            fill: 1,
            fillGradient: 0,
            gridPos: {
              h: 9,
              w: 12,
              x: 0,
              y: 27,
            },
            hiddenSeries: false,
            id: 20,
            legend: {
              alignAsTable: false,
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
            links: [],
            nullPointMode: 'null',
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
                expr: 'sum(increase(envoy_cluster_ext_authz_ok[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'OK',
                refId: 'A',
              },
              {
                expr: 'sum(increase(envoy_cluster_ext_authz_denied[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'Denied',
                refId: 'B',
              },
              {
                expr: 'sum(increase(envoy_cluster_ext_authz_error[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'Error',
                refId: 'C',
              },
              {
                expr: 'sum(increase(envoy_cluster_ext_authz_ok[1m])) + sum(increase(envoy_cluster_ext_authz_denied[1m])) + sum(increase(envoy_cluster_ext_authz_error[1m]))',
                format: 'time_series',
                intervalFactor: 1,
                legendFormat: 'Total',
                refId: 'D',
              },
            ],
            thresholds: [],
            timeFrom: null,
            timeRegions: [],
            timeShift: null,
            title: 'External Auth Requests',
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
        schemaVersion: 22,
        style: 'dark',
        tags: [],
        templating: {
          list: [],
        },
        time: {
          from: 'now-6h',
          to: 'now',
        },
        timepicker: {
          refresh_intervals: [
            '5s',
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
        title: 'Envoy Statistics',
        uid: 'envoy',
        version: 1,
      }, '  '
    ),
  },
};

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

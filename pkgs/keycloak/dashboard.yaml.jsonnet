local common = import '../../lib/common.jsonnet';
local grafana = import '../../lib/grafana.jsonnet';

local dashboardConfig = {
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "description": "Monitoring keycloak metrics",
  "editable": true,
  "gnetId": 10441,
  "graphTooltip": 1,
  "iteration": 1605215425652,
  "links": [],
  "panels": [
    {
      "collapsed": false,
      "datasource": null,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 49,
      "panels": [],
      "title": "Metrics",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 24,
        "x": 0,
        "y": 1
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 35,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "histogram_quantile(0.95, sum(rate(keycloak_request_duration_bucket{route!~\".*\\\\..*\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Request Latency (.95)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:812",
          "decimals": 0,
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:813",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {},
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "light-blue",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "hideTimeOverride": false,
      "id": 40,
      "links": [],
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "last"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "7.2.0",
      "targets": [
        {
          "expr": "wildfly_infinispan_cache_number_of_entries{pod=\"keycloak-0\",type=\"distributed\", name=\"offlineSessions\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Offline Sessions",
          "refId": "A"
        },
        {
          "expr": "wildfly_infinispan_cache_number_of_entries{pod=\"keycloak-0\",type=\"distributed\", name=\"sessions\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "Browser Sessions",
          "refId": "B"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "User Sessions",
      "type": "stat"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 8
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 1,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum by (realm)(rate(keycloak_logins{job=\"keycloak-http\"}[$__rate_interval]))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{realm}} login success",
          "refId": "A"
        },
        {
          "expr": "sum by (realm)(rate(keycloak_user_event_INTROSPECT_TOKEN{job=\"keycloak-http\"}[$__rate_interval]))",
          "interval": "",
          "legendFormat": "{{realm}} token introspect",
          "refId": "B"
        },
        {
          "expr": "sum by (realm)(rate(keycloak_user_event_REFRESH_TOKEN{job=\"keycloak-http\"}[$__rate_interval]))",
          "interval": "",
          "legendFormat": "{{realm}} token refresh",
          "refId": "C"
        },
        {
          "expr": "sum by (realm)(rate(keycloak_failed_login_attempts{job=\"keycloak-http\"}[$__rate_interval]))",
          "interval": "",
          "legendFormat": "{{realm}} login failure",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Events",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1000",
          "decimals": 0,
          "format": "none",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1001",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 16
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 29,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeat": null,
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "histogram_quantile(0.99, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "A"
        },
        {
          "expr": "histogram_quantile(0.99, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token/introspect\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "E"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "OpenID Connect API Latency (0.99)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:812",
          "decimals": 0,
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:813",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 16
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 63,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "histogram_quantile(0.95, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "A"
        },
        {
          "expr": "histogram_quantile(0.95, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token/introspect\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "E"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "OpenID Connect API Latency (0.95)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:812",
          "decimals": 0,
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:813",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 24
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 64,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "histogram_quantile(0.90, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "A"
        },
        {
          "expr": "histogram_quantile(0.90, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token/introspect\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "E"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "OpenID Connect API Latency (0.90)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:812",
          "decimals": 0,
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:813",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 24
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 65,
      "legend": {
        "alignAsTable": true,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "histogram_quantile(0.5, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "A"
        },
        {
          "expr": "histogram_quantile(0.5, sum(rate(keycloak_request_duration_bucket{route=~\"/realms/.*/protocol/openid-connect/token/introspect\"}[$__rate_interval])) by (le, route))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ route }}",
          "refId": "E"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "OpenID Connect API Latency (0.50)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:812",
          "decimals": 0,
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:813",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "datasource": null,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 32
      },
      "id": 58,
      "title": "System Health",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 0,
        "y": 33
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 24,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeat": "Pod",
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-1",
          "value": "keycloak-1"
        }
      },
      "seriesOverrides": [
        {
          "$$hashKey": "object:231",
          "alias": "/.*max.*/",
          "color": "#C4162A",
          "dashes": true,
          "fill": 0,
          "lines": true
        },
        {
          "$$hashKey": "object:445",
          "alias": "container limit",
          "color": "#CA95E5",
          "dashes": true,
          "fill": 0
        },
        {
          "$$hashKey": "object:612",
          "alias": "resident",
          "color": "#96D98D",
          "fill": 0
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "container_spec_memory_limit_bytes{container=\"keycloak\", pod_name=\"$Pod\"}",
          "interval": "",
          "legendFormat": "container limit",
          "refId": "E"
        },
        {
          "expr": "sum(process_resident_memory_bytes{job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "interval": "",
          "legendFormat": "resident",
          "refId": "D"
        },
        {
          "expr": "sum(jvm_memory_bytes_max{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "max heap",
          "refId": "B"
        },
        {
          "expr": "sum(jvm_memory_bytes_committed{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "committed heap",
          "refId": "A"
        },
        {
          "expr": "sum(jvm_memory_bytes_used{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "used heap",
          "refId": "C"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Memory ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1567",
          "decimals": null,
          "format": "bytes",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1568",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 8,
        "y": 33
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 68,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeatIteration": 1605215425652,
      "repeatPanelId": 24,
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-0",
          "value": "keycloak-0"
        }
      },
      "seriesOverrides": [
        {
          "$$hashKey": "object:231",
          "alias": "/.*max.*/",
          "color": "#C4162A",
          "dashes": true,
          "fill": 0,
          "lines": true
        },
        {
          "$$hashKey": "object:445",
          "alias": "container limit",
          "color": "#CA95E5",
          "dashes": true,
          "fill": 0
        },
        {
          "$$hashKey": "object:612",
          "alias": "resident",
          "color": "#96D98D",
          "fill": 0
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "container_spec_memory_limit_bytes{container=\"keycloak\", pod_name=\"$Pod\"}",
          "interval": "",
          "legendFormat": "container limit",
          "refId": "E"
        },
        {
          "expr": "sum(process_resident_memory_bytes{job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "interval": "",
          "legendFormat": "resident",
          "refId": "D"
        },
        {
          "expr": "sum(jvm_memory_bytes_max{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "max heap",
          "refId": "B"
        },
        {
          "expr": "sum(jvm_memory_bytes_committed{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "committed heap",
          "refId": "A"
        },
        {
          "expr": "sum(jvm_memory_bytes_used{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "used heap",
          "refId": "C"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Memory ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1567",
          "decimals": null,
          "format": "bytes",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1568",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 16,
        "y": 33
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 69,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeatIteration": 1605215425652,
      "repeatPanelId": 24,
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-2",
          "value": "keycloak-2"
        }
      },
      "seriesOverrides": [
        {
          "$$hashKey": "object:231",
          "alias": "/.*max.*/",
          "color": "#C4162A",
          "dashes": true,
          "fill": 0,
          "lines": true
        },
        {
          "$$hashKey": "object:445",
          "alias": "container limit",
          "color": "#CA95E5",
          "dashes": true,
          "fill": 0
        },
        {
          "$$hashKey": "object:612",
          "alias": "resident",
          "color": "#96D98D",
          "fill": 0
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "container_spec_memory_limit_bytes{container=\"keycloak\", pod_name=\"$Pod\"}",
          "interval": "",
          "legendFormat": "container limit",
          "refId": "E"
        },
        {
          "expr": "sum(process_resident_memory_bytes{job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "interval": "",
          "legendFormat": "resident",
          "refId": "D"
        },
        {
          "expr": "sum(jvm_memory_bytes_max{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "max heap",
          "refId": "B"
        },
        {
          "expr": "sum(jvm_memory_bytes_committed{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "committed heap",
          "refId": "A"
        },
        {
          "expr": "sum(jvm_memory_bytes_used{area=\"heap\", job=\"keycloak-http\", pod=\"$Pod\"}) by (pod)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "used heap",
          "refId": "C"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Memory ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1567",
          "decimals": null,
          "format": "bytes",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1568",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 8,
        "x": 0,
        "y": 40
      },
      "hiddenSeries": false,
      "id": 67,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "repeat": "Pod",
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-1",
          "value": "keycloak-1"
        }
      },
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "irate(process_cpu_seconds_total{job=\"keycloak-http\", pod=\"$Pod\"}[$__rate_interval]) ",
          "interval": "",
          "legendFormat": "CPU Utilization",
          "refId": "A"
        },
        {
          "expr": "sum(irate(jvm_gc_collection_seconds_sum{job=\"keycloak-http\", pod=\"$Pod\"}[$__rate_interval]))",
          "interval": "",
          "legendFormat": "Garbage Collection",
          "refId": "B"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "CPU / GC ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:517",
          "format": "percentunit",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:518",
          "format": "percent",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 8,
        "x": 8,
        "y": 40
      },
      "hiddenSeries": false,
      "id": 70,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "repeatIteration": 1605215425652,
      "repeatPanelId": 67,
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-0",
          "value": "keycloak-0"
        }
      },
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "irate(process_cpu_seconds_total{job=\"keycloak-http\", pod=$Pod}[$__rate_interval]) ",
          "interval": "",
          "legendFormat": "CPU Utilization",
          "refId": "A"
        },
        {
          "expr": "sum(irate(jvm_gc_collection_seconds_sum{job=\"keycloak-http\", pod=$Pod}[$__rate_interval]))",
          "interval": "",
          "legendFormat": "Garbage Collection",
          "refId": "B"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "CPU / GC ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:517",
          "format": "percentunit",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:518",
          "format": "percent",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 8,
        "x": 16,
        "y": 40
      },
      "hiddenSeries": false,
      "id": 71,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "repeatIteration": 1605215425652,
      "repeatPanelId": 67,
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-2",
          "value": "keycloak-2"
        }
      },
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "irate(process_cpu_seconds_total{job=\"keycloak-http\", pod=$Pod}[$__rate_interval]) ",
          "interval": "",
          "legendFormat": "CPU Utilization",
          "refId": "A"
        },
        {
          "expr": "sum(irate(jvm_gc_collection_seconds_sum{job=\"keycloak-http\", pod=$Pod}[$__rate_interval]))",
          "interval": "",
          "legendFormat": "Garbage Collection",
          "refId": "B"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "CPU / GC ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:517",
          "format": "percentunit",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:518",
          "format": "percent",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 0,
        "y": 48
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 30,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeat": "Pod",
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-1",
          "value": "keycloak-1"
        }
      },
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(jvm_threads_current{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "current",
          "refId": "A"
        },
        {
          "expr": "sum(jvm_threads_daemon{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "daemon",
          "refId": "B"
        },
        {
          "expr": "sum(jvm_threads_deadlocked_monitor{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "deadlocked monitor",
          "refId": "C"
        },
        {
          "expr": "sum(jvm_threads_deadlocked{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "deadlocked",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Threads ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1617",
          "decimals": null,
          "format": "short",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1618",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 8,
        "y": 48
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 72,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeatIteration": 1605215425652,
      "repeatPanelId": 30,
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-0",
          "value": "keycloak-0"
        }
      },
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(jvm_threads_current{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "current",
          "refId": "A"
        },
        {
          "expr": "sum(jvm_threads_daemon{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "daemon",
          "refId": "B"
        },
        {
          "expr": "sum(jvm_threads_deadlocked_monitor{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "deadlocked monitor",
          "refId": "C"
        },
        {
          "expr": "sum(jvm_threads_deadlocked{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "deadlocked",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Threads ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1617",
          "decimals": null,
          "format": "short",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1618",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 2,
      "fillGradient": 0,
      "gridPos": {
        "h": 7,
        "w": 8,
        "x": 16,
        "y": 48
      },
      "hiddenSeries": false,
      "hideTimeOverride": false,
      "id": 73,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "sideWidth": 100,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.2.0",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeatIteration": 1605215425652,
      "repeatPanelId": 30,
      "scopedVars": {
        "Pod": {
          "selected": false,
          "text": "keycloak-2",
          "value": "keycloak-2"
        }
      },
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(jvm_threads_current{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "current",
          "refId": "A"
        },
        {
          "expr": "sum(jvm_threads_daemon{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "daemon",
          "refId": "B"
        },
        {
          "expr": "sum(jvm_threads_deadlocked_monitor{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "deadlocked monitor",
          "refId": "C"
        },
        {
          "expr": "sum(jvm_threads_deadlocked{job=\"keycloak-http\",pod=\"$Pod\"}) by (pod) ",
          "interval": "",
          "legendFormat": "deadlocked",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Threads ($Pod)",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1617",
          "decimals": null,
          "format": "short",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:1618",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": false
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    }
  ],
  "refresh": "10s",
  "schemaVersion": 26,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "allValue": "*",
        "current": {
          "selected": false,
          "text": "All",
          "value": "$__all"
        },
        "datasource": "$datasource",
        "definition": "label_values(jvm_info{job=\"keycloak-http\"}, pod)",
        "hide": 2,
        "includeAll": true,
        "label": "Pod",
        "multi": false,
        "name": "Pod",
        "options": [],
        "query": "label_values(jvm_info{job=\"keycloak-http\"}, pod)",
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "Prometheus",
          "value": "Prometheus"
        },
        "hide": 2,
        "includeAll": false,
        "label": null,
        "multi": false,
        "name": "datasource",
        "options": [],
        "query": "prometheus",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "type": "datasource"
      }
    ]
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {
    "hidden": false,
    "refresh_intervals": [
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ]
  },
  "timezone": "",
  "title": "Keycloak Metrics",
  "uid": "keycloak",
  "version": 11
};

local configmap(me) = grafana.dashboard(me, me.pkg, dashboardConfig);

function(config, prev, namespace, pkg) configmap(common.package(config, prev, namespace, pkg))

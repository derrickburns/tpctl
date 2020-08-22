local common = import '../../../lib/common.jsonnet';
local grafana = import '../../../lib/grafana.jsonnet';

local dashboardConfig = {
{
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
  "description": "A dashboard to help manage Kubernetes cluster costs and resources",
  "editable": false,
  "gnetId": 6873,
  "graphTooltip": 0,
  "id": 1275,
  "iteration": 1598137947725,
  "links": [],
  "panels": [
    {
      "content": "This dashboard shows monthly cost estimates for the cluster, based on **current** CPU, RAM and storage provisioned.",
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "gridPos": {
        "h": 2,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 86,
      "links": [],
      "mode": "markdown",
      "options": {
        "content": "This dashboard shows monthly cost estimates for the cluster, based on **current** CPU, RAM and storage provisioned.",
        "mode": "markdown"
      },
      "pluginVersion": "7.1.0",
      "title": "",
      "transparent": true,
      "type": "text"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": false,
      "colors": [
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "currencyUSD",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": false,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 0,
        "y": 2
      },
      "hideTimeOverride": true,
      "id": 75,
      "interval": null,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": " ",
      "targets": [
        {
          "expr": "sum(\n (\n (\n sum(kube_node_status_capacity_cpu_cores) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible=\"true\"}) by (node)\n ) * $costpcpu\n )\n or\n (\n (\n sum(kube_node_status_capacity_cpu_cores) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible!=\"true\"}) by (node)\n ) * ($costcpu - ($costcpu / 100 * $costDiscount))\n )\n) ",
          "format": "time_series",
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": " {{ node }}",
          "refId": "A"
        }
      ],
      "thresholds": "",
      "timeFrom": "15m",
      "timeShift": null,
      "title": "CPU Cost",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": false,
      "colors": [
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "currencyUSD",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": false,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 6,
        "y": 2
      },
      "hideTimeOverride": true,
      "id": 77,
      "interval": null,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": " ",
      "targets": [
        {
          "expr": "sum(\n (\n (\n sum(kube_node_status_capacity_memory_bytes) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible=\"true\"}) by (node)\n ) /1024/1024/1024 * $costpram\n )\n or\n (\n (\n sum(kube_node_status_capacity_memory_bytes) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible!=\"true\"}) by (node)\n ) /1024/1024/1024 * ($costram - ($costram / 100 * $costDiscount))\n)\n) ",
          "format": "time_series",
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": " {{ node }}",
          "refId": "A"
        }
      ],
      "thresholds": "",
      "timeFrom": "15m",
      "timeShift": null,
      "title": "RAM Cost",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": false,
      "colors": [
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "currencyUSD",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": false,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 12,
        "y": 2
      },
      "hideTimeOverride": true,
      "id": 78,
      "interval": null,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": " ",
      "targets": [
        {
          "expr": "sum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n) / 1024 / 1024 /1024 * $costStorageSSD\n\n+\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n) / 1024 / 1024 /1024 * $costStorageStandard\n\n+ \n\nsum(container_fs_limit_bytes{id=\"/\"}) / 1024 / 1024 / 1024 * 1.03 * $costStorageStandard",
          "format": "time_series",
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": " {{ node }}",
          "refId": "A"
        }
      ],
      "thresholds": "",
      "timeFrom": "15m",
      "timeShift": null,
      "title": "Storage Cost (Cluster and PVC)",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": false,
      "colors": [
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "description": "Represents a near worst-case approximation of network costs.",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "currencyUSD",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": false,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 18,
        "y": 2
      },
      "hideTimeOverride": true,
      "id": 129,
      "interval": null,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": " ",
      "targets": [
        {
          "expr": "SUM(rate(node_network_transmit_bytes_total{device=\"eth0\"}[60m]) / 1024 / 1024 / 1024 ) * (60 * 60 * 24 * 30) * $costEgress",
          "format": "time_series",
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": " {{ node }}",
          "refId": "A"
        }
      ],
      "thresholds": "",
      "timeFrom": "15m",
      "timeShift": null,
      "title": "Network Egress Cost",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": true,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(50, 172, 45, 0.97)",
        "#c15c17"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "description": "Current CPU use from applications divided by allocatable CPUs",
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "percent",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": true,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 3,
        "x": 0,
        "y": 6
      },
      "height": "180px",
      "hideTimeOverride": true,
      "id": 82,
      "interval": null,
      "isNew": true,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": "",
      "targets": [
        {
          "expr": "(\n sum(\n count(irate(container_cpu_usage_seconds_total{id=\"/\"}[10m])) by (instance)\n * on (instance) \n sum(irate(container_cpu_usage_seconds_total{id=\"/\"}[10m])) by (instance)\n ) \n / \n (sum (kube_node_status_allocatable_cpu_cores))\n) * 100",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "refId": "A",
          "step": 10
        }
      ],
      "thresholds": "30, 80",
      "timeFrom": "",
      "title": "CPU Utilization",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": true,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(50, 172, 45, 0.97)",
        "#c15c17"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "description": "Current CPU reservation requests from applications vs allocatable CPU",
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "percent",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": true,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 3,
        "x": 3,
        "y": 6
      },
      "height": "180px",
      "id": 91,
      "interval": null,
      "isNew": true,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": "",
      "targets": [
        {
          "expr": "SUM(kube_pod_container_resource_requests_cpu_cores) / SUM(kube_node_status_allocatable_cpu_cores) * 100",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "refId": "A",
          "step": 10
        }
      ],
      "thresholds": "30, 80",
      "title": "CPU Requests",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": true,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(50, 172, 45, 0.97)",
        "#c15c17"
      ],
      "datasource": "$datasource",
      "description": "Current RAM use vs RAM available",
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "percent",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": true,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 3,
        "x": 6,
        "y": 6
      },
      "height": "180px",
      "hideTimeOverride": true,
      "id": 80,
      "interval": null,
      "isNew": true,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": "",
      "targets": [
        {
          "expr": "SUM(container_memory_usage_bytes{namespace!=\"\"}) / SUM(kube_node_status_allocatable_memory_bytes) * 100",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "refId": "A",
          "step": 10
        },
        {
          "expr": "",
          "format": "time_series",
          "intervalFactor": 1,
          "refId": "B"
        }
      ],
      "thresholds": "30,80",
      "timeFrom": "",
      "title": "RAM Utilization",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": true,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(50, 172, 45, 0.97)",
        "#c15c17"
      ],
      "datasource": "$datasource",
      "description": "Current RAM requests vs RAM available",
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "percent",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": true,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 3,
        "x": 9,
        "y": 6
      },
      "height": "180px",
      "id": 92,
      "interval": null,
      "isNew": true,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": "",
      "targets": [
        {
          "expr": "(\n sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\"})\n /\n sum(kube_node_status_allocatable_memory_bytes)\n) * 100",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "refId": "A",
          "step": 10
        }
      ],
      "thresholds": "30,80",
      "title": "RAM Requests",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": true,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(50, 172, 45, 0.97)",
        "#c15c17"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "description": "This gauge shows the current standard storage use, including cluster storage, vs storage available",
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "percent",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": true,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 3,
        "x": 12,
        "y": 6
      },
      "height": "180px",
      "hideTimeOverride": true,
      "id": 95,
      "interval": null,
      "isNew": true,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": "",
      "targets": [
        {
          "expr": "sum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kubelet_volume_stats_used_bytes) by (persistentvolumeclaim, namespace) or up * 0\n + sum(container_fs_usage_bytes{device=~\"^/dev/[sv]d[a-z][1-9]$\",id=\"/\"})\n) /\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n + sum(container_fs_limit_bytes{device=~\"^/dev/[sv]d[a-z][1-9]$\",id=\"/\"})\n) * 100",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "refId": "A",
          "step": 10
        }
      ],
      "thresholds": "30, 80",
      "timeFrom": "",
      "title": "Storage Utilization",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": true,
      "colors": [
        "rgba(245, 54, 54, 0.9)",
        "rgba(50, 172, 45, 0.97)",
        "#c15c17"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "description": "This gauge shows the current SSD use vs SSD available",
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "percent",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": true,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 3,
        "x": 15,
        "y": 6
      },
      "height": "180px",
      "hideTimeOverride": true,
      "id": 96,
      "interval": null,
      "isNew": true,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": "",
      "targets": [
        {
          "expr": "sum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kubelet_volume_stats_used_bytes) by (persistentvolumeclaim, namespace)\n) /\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace)\n) * 100",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "refId": "A",
          "step": 10
        }
      ],
      "thresholds": "30, 80",
      "timeFrom": "",
      "title": "SSD Utilization",
      "type": "singlestat",
      "valueFontSize": "80%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "cacheTimeout": null,
      "colorBackground": false,
      "colorValue": false,
      "colors": [
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a"
      ],
      "datasource": "$datasource",
      "decimals": 2,
      "description": "Expected monthly cost given current CPU, memory storage, and network resource consumption",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "format": "currencyUSD",
      "gauge": {
        "maxValue": 100,
        "minValue": 0,
        "show": false,
        "thresholdLabels": false,
        "thresholdMarkers": true
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 18,
        "y": 6
      },
      "hideTimeOverride": true,
      "id": 93,
      "interval": null,
      "links": [],
      "mappingType": 1,
      "mappingTypes": [
        {
          "name": "value to text",
          "value": 1
        },
        {
          "name": "range to text",
          "value": 2
        }
      ],
      "maxDataPoints": 100,
      "nullPointMode": "connected",
      "nullText": null,
      "postfix": "",
      "postfixFontSize": "50%",
      "prefix": "",
      "prefixFontSize": "50%",
      "rangeMaps": [
        {
          "from": "null",
          "text": "N/A",
          "to": "null"
        }
      ],
      "sparkline": {
        "fillColor": "rgba(31, 118, 189, 0.18)",
        "full": false,
        "lineColor": "rgb(31, 120, 193)",
        "show": false
      },
      "tableColumn": " ",
      "targets": [
        {
          "expr": "# CPU\nsum(\n (\n (\n sum(kube_node_status_capacity_cpu_cores) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible=\"true\"}) by (node)\n ) * $costpcpu\n )\n or\n (\n (\n sum(kube_node_status_capacity_cpu_cores) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible!=\"true\"}) by (node)\n ) * ($costcpu - ($costcpu / 100 * $costDiscount))\n )\n) \n\n+ \n\n# Storage\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n) / 1024 / 1024 /1024 * $costStorageSSD\n\n+\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n) / 1024 / 1024 /1024 * $costStorageStandard\n\n+ \n\nsum(container_fs_limit_bytes{id=\"/\"}) / 1024 / 1024 / 1024 * 1.03 * $costStorageStandard \n\n+\n\n# END STORAGE\n# RAM \nsum(\n (\n (\n sum(kube_node_status_capacity_memory_bytes) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible=\"true\"}) by (node)\n ) /1024/1024/1024 * $costpram\n )\n or\n (\n (\n sum(kube_node_status_capacity_memory_bytes) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible!=\"true\"}) by (node)\n ) /1024/1024/1024 * ($costram - ($costram / 100 * $costDiscount))\n)\n)\n\n+\n\n#Network \nSUM(rate(node_network_transmit_bytes_total{device=\"eth0\"}[60m]) / 1024 / 1024 / 1024 ) * (60 * 60 * 24 * 30) * $costEgress",
          "format": "time_series",
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": " {{ node }}",
          "refId": "A"
        }
      ],
      "thresholds": "",
      "timeFrom": "15m",
      "timeShift": null,
      "title": "Total Monthly Cost",
      "type": "singlestat",
      "valueFontSize": "120%",
      "valueMaps": [
        {
          "op": "=",
          "text": "N/A",
          "value": "null"
        }
      ],
      "valueName": "current"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "$datasource",
      "description": "Expected monthly CPU, memory and storage costs given provisioned resources",
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
        "y": 10
      },
      "hiddenSeries": false,
      "id": 120,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": false,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "# CPU\nsum(\n (\n (\n sum(kube_node_status_capacity_cpu_cores) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible=\"true\"}) by (node)\n ) * $costpcpu\n )\n or\n (\n (\n sum(kube_node_status_capacity_cpu_cores) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible!=\"true\"}) by (node)\n ) * ($costcpu - ($costcpu / 100 * $costDiscount))\n )\n) \n\n+ \n\n# Storage\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n) / 1024 / 1024 /1024 * $costStorageSSD\n\n+\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) or up * 0\n) / 1024 / 1024 /1024 * $costStorageStandard\n\n+ \n\nsum(container_fs_limit_bytes{id=\"/\"}) / 1024 / 1024 / 1024 * 1.03 * $costStorageStandard \n\n+\n\n# END STORAGE\n# RAM \nsum(\n (\n (\n sum(kube_node_status_capacity_memory_bytes) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible=\"true\"}) by (node)\n ) /1024/1024/1024 * $costpram\n )\n or\n (\n (\n sum(kube_node_status_capacity_memory_bytes) by (node)\n * on (node) group_left (label_cloud_google_com_gke_preemptible)\n avg(kube_node_labels{label_cloud_google_com_gke_preemptible!=\"true\"}) by (node)\n ) /1024/1024/1024 * ($costram - ($costram / 100 * $costDiscount))\n)\n) \n\n+\n\n#Network \nSUM(rate(node_network_transmit_bytes_total{device=\"eth0\"}[60m]) / 1024 / 1024 / 1024 ) * (60 * 60 * 24 * 30) * $costEgress",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "cluster cost",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Total monthly cost",
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
          "format": "currencyUSD",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "description": "Resources allocated to namespace based on container requests",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 10
      },
      "hideTimeOverride": false,
      "id": 73,
      "links": [],
      "pageSize": 10,
      "repeat": null,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 7,
        "desc": true
      },
      "styles": [
        {
          "alias": "Namespace",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(50, 172, 45, 0.97)",
            "#c15c17"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "link": true,
          "linkTooltip": "View namespace cost metrics",
          "linkUrl": "d/at-cost-analysis-namespace2/namespace-cost-metrics?&var-namespace=$__cell",
          "pattern": "namespace",
          "thresholds": [
            "30",
            "80"
          ],
          "type": "string",
          "unit": "currencyUSD"
        },
        {
          "alias": "RAM",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "pattern": "Value #B",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "CPU",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "PV Storage",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #C",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "Total",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #D",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "CPU Utilization",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "#bf1b00",
            "rgba(50, 172, 45, 0.97)",
            "#ef843c"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #E",
          "thresholds": [
            "30",
            "80"
          ],
          "type": "number",
          "unit": "percent"
        },
        {
          "alias": "RAM Utilization",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(50, 172, 45, 0.97)",
            "#ef843c"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #F",
          "thresholds": [
            "30",
            "80"
          ],
          "type": "number",
          "unit": "percent"
        }
      ],
      "targets": [
        {
          "expr": "(\n sum(kube_pod_container_resource_requests_cpu_cores{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible!=\"true\"}*($costcpu - ($costcpu / 100 * $costDiscount))) by(namespace)\n or\n count(\n count(container_spec_cpu_shares{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)\n\n+\n\n(\n sum(kube_pod_container_resource_requests_cpu_cores{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible=\"true\"}*$costpcpu) by(namespace)\n or\n count(\n count(container_spec_cpu_shares{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)",
          "format": "table",
          "hide": false,
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ namespace }}",
          "refId": "A"
        },
        {
          "expr": "(\n sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible!=\"true\"} / 1024 / 1024 / 1024*($costram- ($costram / 100 * $costDiscount))) by (namespace) \n or\n count(\n count(container_spec_memory_limit_bytes{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)\n\n+\n\n(\n sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible=\"true\"} / 1024 / 1024 / 1024 * $costpram ) by (namespace) \n or\n count(\n count(container_spec_memory_limit_bytes{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "legendFormat": "{{ namespace }}",
          "refId": "B"
        },
        {
          "expr": "sum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) \n) by (namespace) / 1024 / 1024 /1024 * $costStorageSSD \n\nor\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) \n) by (namespace) / 1024 / 1024 /1024 * $costStorageStandard",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "legendFormat": "{{ namespace }}",
          "refId": "C"
        },
        {
          "expr": "# CPU \n(\n sum(kube_pod_container_resource_requests_cpu_cores{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible!=\"true\"}*($costcpu - ($costcpu / 100 * $costDiscount))) by(namespace)\n or\n count(\n count(container_spec_cpu_shares{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)\n\n+\n\n(\n sum(kube_pod_container_resource_requests_cpu_cores{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible=\"true\"}*$costpcpu) by(namespace)\n or\n count(\n count(container_spec_cpu_shares{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)\n\n+\n\n#END CPU \n# Memory \n\n(\n sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible!=\"true\"} / 1024 / 1024 / 1024*($costram- ($costram / 100 * $costDiscount))) by (namespace) \n or\n count(\n count(container_spec_memory_limit_bytes{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)\n\n+\n\n(\n sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\",namespace!=\"kube-system\",cloud_google_com_gke_preemptible=\"true\"} / 1024 / 1024 / 1024 * $costpram ) by (namespace) \n or\n count(\n count(container_spec_memory_limit_bytes{namespace!=\"\",namespace!=\"kube-system\"}) by(namespace)\n ) by(namespace) -1\n)\n\n+\n\n# PV storage\n\n(\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) \n) by (namespace) / 1024 / 1024 /1024 * $costStorageSSD \n\nor\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n + on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes) by (persistentvolumeclaim, namespace) \n) by (namespace) / 1024 / 1024 /1024 * $costStorageStandard \n)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "legendFormat": "Total",
          "refId": "D"
        }
      ],
      "timeFrom": "",
      "timeShift": null,
      "title": "Namespace cost allocation",
      "transform": "table",
      "type": "table-old"
    },
    {
      "collapsed": false,
      "datasource": null,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 18
      },
      "id": 108,
      "panels": [],
      "title": "CPU Metrics",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 19
      },
      "hiddenSeries": false,
      "id": 116,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "SUM(kube_node_status_capacity_cpu_cores)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "capacity",
          "refId": "A"
        },
        {
          "expr": "SUM(kube_pod_container_resource_requests_cpu_cores)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "requests",
          "refId": "C"
        },
        {
          "expr": "SUM(irate(container_cpu_usage_seconds_total{id=\"/\"}[5m]))",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "usage",
          "refId": "B"
        },
        {
          "expr": "SUM(kube_pod_container_resource_limits_cpu_cores) ",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "limits",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Cluster CPUs",
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
          "decimals": 1,
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
        "w": 24,
        "x": 0,
        "y": 27
      },
      "hiddenSeries": false,
      "id": 130,
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
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "avg(irate(node_cpu_seconds_total{mode!=\"idle\"}[5m])) by (mode) * 100",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{mode}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "CPU Mode",
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
          "format": "percent",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "percent",
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
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "description": "This table shows the comparison of CPU requests and usage by namespace",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 0,
        "y": 35
      },
      "hideTimeOverride": true,
      "id": 104,
      "links": [],
      "pageSize": 8,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 1,
        "desc": true
      },
      "styles": [
        {
          "alias": "CPU Requests",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "#fceaca",
            "#fce2de",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [
            ""
          ],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Node",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "node",
          "thresholds": [],
          "type": "string",
          "unit": "short"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "CPU Requests",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(50, 172, 45, 0.97)",
            "#cffaff"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #B",
          "thresholds": [
            ""
          ],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "24h CPU Usage",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #C",
          "thresholds": [
            "30"
          ],
          "type": "number",
          "unit": "none"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "link": true,
          "linkTooltip": "View namespace cost metrics",
          "linkUrl": "d/at-cost-analysis-namespace2/namespace-cost-metrics?&var-namespace=$__cell",
          "mappingType": 1,
          "pattern": "namespace",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        }
      ],
      "targets": [
        {
          "expr": "sum(kube_pod_container_resource_requests_cpu_cores{namespace!=\"\"}) by (namespace) ",
          "format": "table",
          "hide": false,
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A"
        },
        {
          "expr": "sum (rate (container_cpu_usage_seconds_total{image!=\"\",namespace!=\"\"}[24h])) by (namespace)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "legendFormat": "{{ namespace }}",
          "refId": "C"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "CPU request utilization by namespace",
      "transform": "table",
      "type": "table-old"
    },
    {
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "description": "This table shows the comparison of application CPU usage vs the capacity of the node (measured over last 60 minutes)",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 12,
        "y": 35
      },
      "hideTimeOverride": true,
      "id": 90,
      "links": [],
      "pageSize": 8,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 2,
        "desc": true
      },
      "styles": [
        {
          "alias": "CPU Request Utilization",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "#ef843c",
            "rgba(50, 172, 45, 0.97)",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [
            ".30",
            " .80"
          ],
          "type": "number",
          "unit": "percentunit"
        },
        {
          "alias": "Node",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "node",
          "thresholds": [],
          "type": "string",
          "unit": "short"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "CPU Utilization",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "#ef843c",
            "rgba(50, 172, 45, 0.97)",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #B",
          "thresholds": [
            ".20",
            " .80"
          ],
          "type": "number",
          "unit": "percentunit"
        },
        {
          "alias": "24h Utilization ",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value",
          "thresholds": [],
          "type": "number",
          "unit": "percentunit"
        }
      ],
      "targets": [
        {
          "expr": "SUM(\nSUM(rate(container_cpu_usage_seconds_total[24h])) by (pod_name)\n* on (pod_name) group_left (node) \nlabel_replace(\n avg(kube_pod_info{}),\n \"pod_name\", \n \"$1\", \n \"pod\", \n \"(.+)\"\n)\n) by (node) \n/ \nsum(kube_node_status_capacity_cpu_cores) by (node)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "B"
        },
        {
          "expr": "sum(kube_pod_container_resource_requests_cpu_cores) by (node) / sum(kube_node_status_capacity_cpu_cores) by (node)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "A"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Cluster cost & utilization by node",
      "transform": "table",
      "type": "table-old"
    },
    {
      "collapsed": false,
      "datasource": null,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 45
      },
      "id": 113,
      "panels": [],
      "title": "Memory Metrics",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 46
      },
      "hiddenSeries": false,
      "id": 117,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": false,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "SUM(kube_node_status_capacity_memory_bytes / 1024 / 1024 / 1024)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "capacity",
          "refId": "A"
        },
        {
          "expr": "SUM(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\"} / 1024 / 1024 / 1024)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "requests",
          "refId": "C"
        },
        {
          "expr": "SUM(container_memory_usage_bytes{image!=\"\"} / 1024 / 1024 / 1024)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "usage",
          "refId": "B"
        },
        {
          "expr": "SUM(kube_pod_container_resource_limits_memory_bytes {namespace!=\"\"} / 1024 / 1024 / 1024)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "limits",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Cluster memory (GB)",
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
          "format": "decgbytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
        "w": 24,
        "x": 0,
        "y": 54
      },
      "hiddenSeries": false,
      "id": 131,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": false,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "1 - sum(node_memory_MemAvailable_bytes) by (node) / sum(node_memory_MemTotal_bytes) by (node)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "usage",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Cluster Memory Utilization",
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
          "format": "percentunit",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "description": "Comparison of memory requests and current usage by namespace",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 0,
        "y": 62
      },
      "hideTimeOverride": true,
      "id": 109,
      "links": [],
      "pageSize": 7,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 1,
        "desc": true
      },
      "styles": [
        {
          "alias": "Mem Requests (GB)",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "#fceaca",
            "#fce2de",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [
            ""
          ],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Node",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "node",
          "thresholds": [],
          "type": "string",
          "unit": "short"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "CPU Requests",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(50, 172, 45, 0.97)",
            "#cffaff"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #B",
          "thresholds": [
            ""
          ],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "24h Mem Usage",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "#508642",
            "#e5ac0e"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #C",
          "thresholds": [
            ".30",
            ".75"
          ],
          "type": "number",
          "unit": "none"
        },
        {
          "alias": "Namespace",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "link": true,
          "linkTooltip": "View namespace cost metrics",
          "linkUrl": "d/at-cost-analysis-namespace2/namespace-cost-metrics?&var-namespace=$__cell",
          "mappingType": 1,
          "pattern": "namespace",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        }
      ],
      "targets": [
        {
          "expr": "sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\"} / 1024 / 1024 / 1024) by (namespace) ",
          "format": "table",
          "hide": false,
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A"
        },
        {
          "expr": "SUM(container_memory_usage_bytes{image!=\"\",namespace!=\"\"} / 1024 / 1024 / 1024) by (namespace)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "C"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Memory requests & utilization by namespace",
      "transform": "table",
      "type": "table-old"
    },
    {
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "description": "Container RAM usage vs node capacity",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 12,
        "y": 62
      },
      "hideTimeOverride": true,
      "id": 114,
      "links": [],
      "pageSize": 8,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 1,
        "desc": true
      },
      "styles": [
        {
          "alias": "RAM Requests",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "#ef843c",
            "rgba(50, 172, 45, 0.97)",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [
            "30",
            " 80"
          ],
          "type": "number",
          "unit": "percentunit"
        },
        {
          "alias": "Node",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "node",
          "thresholds": [],
          "type": "string",
          "unit": "short"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "RAM Usage",
          "align": "auto",
          "colorMode": "value",
          "colors": [
            "#ef843c",
            "rgba(50, 172, 45, 0.97)",
            "rgba(245, 54, 54, 0.9)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #B",
          "thresholds": [
            "25",
            " 80"
          ],
          "type": "number",
          "unit": "percent"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        }
      ],
      "targets": [
        {
          "expr": "SUM(label_replace(container_memory_usage_bytes{namespace!=\"\"}, \"node\", \"$1\", \"instance\",\"(.+)\")) by (node) * 100\n/\nSUM(kube_node_status_capacity_memory_bytes) by (node)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "B"
        },
        {
          "expr": "sum(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\"}) by (node) / SUM(kube_node_status_capacity_memory_bytes) by (node)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "A"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Node utilization of allocatable RAM",
      "transform": "table",
      "type": "table-old"
    },
    {
      "collapsed": false,
      "datasource": null,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 72
      },
      "id": 101,
      "panels": [],
      "title": "Storage Metrics",
      "type": "row"
    },
    {
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 73
      },
      "hideTimeOverride": true,
      "id": 97,
      "links": [],
      "pageSize": 8,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 4,
        "desc": true
      },
      "styles": [
        {
          "alias": "Node",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "instance",
          "thresholds": [],
          "type": "string",
          "unit": "short"
        },
        {
          "alias": "PVC Name",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "persistentvolumeclaim",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Storage Class",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "storageclass",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Cost",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "Cost",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "Size (GB)",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #B",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Usage",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #C",
          "thresholds": [],
          "type": "number",
          "unit": "percentunit"
        }
      ],
      "targets": [
        {
          "expr": "SUM(container_fs_limit_bytes{id=\"/\"}) by (instance) / 1024 / 1024 / 1024 * 1.03",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "B"
        },
        {
          "expr": "SUM(container_fs_limit_bytes{id=\"/\"}) by (instance) / 1024 / 1024 / 1024 * 1.03 * $costStorageStandard\n",
          "format": "table",
          "hide": false,
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ persistentvolumeclaim }}",
          "refId": "A"
        },
        {
          "expr": "sum(container_fs_usage_bytes{device=~\"^/dev/[sv]d[a-z][1-9]$\",id=\"/\"} / container_fs_limit_bytes{device=~\"^/dev/[sv]d[a-z][1-9]$\",id=\"/\"}) by (instance) \n",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "C"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Local Storage",
      "transform": "table",
      "type": "table-old"
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
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 73
      },
      "hiddenSeries": false,
      "id": 128,
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
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "SUM(container_fs_usage_bytes{id=\"/\"}) / SUM(container_fs_limit_bytes{id=\"/\"})",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "reads",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Local storage utilization",
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
          "format": "percent",
          "label": "IOPS",
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
      "columns": [
        {
          "text": "Avg",
          "value": "avg"
        }
      ],
      "datasource": "$datasource",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fontSize": "100%",
      "gridPos": {
        "h": 10,
        "w": 12,
        "x": 0,
        "y": 82
      },
      "hideTimeOverride": true,
      "id": 94,
      "links": [],
      "pageSize": 10,
      "repeatDirection": "v",
      "scroll": true,
      "showHeader": true,
      "sort": {
        "col": 2,
        "desc": true
      },
      "styles": [
        {
          "alias": "Namespace",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "link": true,
          "linkTooltip": "View namespace cost metrics",
          "linkUrl": "d/at-cost-analysis-namespace2/namespace-cost-metrics?&var-namespace=$__cell",
          "mappingType": 1,
          "pattern": "namespace",
          "thresholds": [],
          "type": "string",
          "unit": "short"
        },
        {
          "alias": "PVC Name",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "persistentvolumeclaim",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Storage Class",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "storageclass",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        },
        {
          "alias": "Cost",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Time",
          "thresholds": [],
          "type": "hidden",
          "unit": "short"
        },
        {
          "alias": "Cost",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #A",
          "thresholds": [],
          "type": "number",
          "unit": "currencyUSD"
        },
        {
          "alias": "Usage",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #B",
          "thresholds": [],
          "type": "number",
          "unit": "percentunit"
        },
        {
          "alias": "Size (GB)",
          "align": "auto",
          "colorMode": null,
          "colors": [
            "rgba(245, 54, 54, 0.9)",
            "rgba(237, 129, 40, 0.89)",
            "rgba(50, 172, 45, 0.97)"
          ],
          "dateFormat": "YYYY-MM-DD HH:mm:ss",
          "decimals": 2,
          "mappingType": 1,
          "pattern": "Value #C",
          "thresholds": [],
          "type": "number",
          "unit": "short"
        }
      ],
      "targets": [
        {
          "expr": "sum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n * on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace)\n) by (namespace,persistentvolumeclaim,storageclass) / 1024 / 1024 /1024\n\nor\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n * on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace)\n) by (namespace,persistentvolumeclaim,storageclass) / 1024 / 1024 /1024\n\n\n",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "C"
        },
        {
          "expr": "sum (\n sum(kube_persistentvolumeclaim_info{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n * on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes{storageclass=~\".*ssd.*\"}) by (persistentvolumeclaim, namespace)\n) by (namespace,persistentvolumeclaim,storageclass) / 1024 / 1024 /1024 * $costStorageSSD\n\nor\n\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n * on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace)\n) by (namespace,persistentvolumeclaim,storageclass) / 1024 / 1024 /1024 * $costStorageStandard\n",
          "format": "table",
          "hide": false,
          "instant": true,
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "{{ persistentvolumeclaim }}",
          "refId": "A"
        },
        {
          "expr": "sum(kubelet_volume_stats_used_bytes) by (persistentvolumeclaim, namespace) \n/\nsum (\n sum(kube_persistentvolumeclaim_info{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace, storageclass)\n * on (persistentvolumeclaim, namespace) group_right(storageclass)\n sum(kube_persistentvolumeclaim_resource_requests_storage_bytes{storageclass!~\".*ssd.*\"}) by (persistentvolumeclaim, namespace)\n) by (namespace,persistentvolumeclaim)",
          "format": "table",
          "instant": true,
          "intervalFactor": 1,
          "refId": "B"
        }
      ],
      "timeFrom": null,
      "timeShift": null,
      "title": "Persistent Volume Claims",
      "transform": "table",
      "type": "table-old"
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
        "h": 10,
        "w": 12,
        "x": 12,
        "y": 82
      },
      "hiddenSeries": false,
      "id": 132,
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
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "SUM(rate(node_disk_reads_completed_total[10m])) or SUM(rate(node_disk_reads_completed[10m]))\n",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "reads",
          "refId": "D"
        },
        {
          "expr": "SUM(rate(node_disk_writes_completed_total[10m])) or SUM(rate(node_disk_writes_completed[10m]))",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "writes",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Disk IOPS",
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
          "format": "none",
          "label": "IOPS",
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 24,
        "x": 0,
        "y": 92
      },
      "hiddenSeries": false,
      "id": 122,
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
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "SUM( kubelet_volume_stats_inodes_used / kubelet_volume_stats_inodes) by (persistentvolumeclaim) * 100",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Inode usage",
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
          "format": "percent",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
      "collapsed": false,
      "datasource": null,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 101
      },
      "id": 127,
      "panels": [],
      "title": "Network",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 24,
        "x": 0,
        "y": 102
      },
      "hiddenSeries": false,
      "id": 123,
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
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pluginVersion": "7.1.1",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum (rate (node_network_transmit_bytes_total{}[60m]))\n",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "node_out",
          "refId": "B"
        },
        {
          "expr": "SUM ( rate(node_network_transmit_bytes_total{device=\"eth0\"}[60m]))",
          "format": "time_series",
          "instant": false,
          "intervalFactor": 1,
          "legendFormat": "eth0 out",
          "refId": "C"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Node network transmit",
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
          "format": "decbytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
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
    }
  ],
  "refresh": "15m",
  "schemaVersion": 26,
  "style": "dark",
  "tags": [
    "cost",
    "utilization",
    "metrics"
  ],
  "templating": {
    "list": [
      {
        "current": {
          "text": "23.076",
          "value": "23.076"
        },
        "hide": 0,
        "label": "CPU",
        "name": "costcpu",
        "options": [
          {
            "text": "23.076",
            "value": "23.076"
          }
        ],
        "query": "23.076",
        "queryValue": "",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": "5.10",
          "value": "5.10"
        },
        "hide": 0,
        "label": "PE CPU",
        "name": "costpcpu",
        "options": [
          {
            "text": "5.10",
            "value": "5.10"
          }
        ],
        "query": "5.10",
        "queryValue": "",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": "3.25",
          "value": "3.25"
        },
        "hide": 0,
        "label": "RAM",
        "name": "costram",
        "options": [
          {
            "text": "3.25",
            "value": "3.25"
          }
        ],
        "query": "3.25",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": "0.6862",
          "value": "0.6862"
        },
        "hide": 0,
        "label": "PE RAM",
        "name": "costpram",
        "options": [
          {
            "text": "0.6862",
            "value": "0.6862"
          }
        ],
        "query": "0.6862",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": "0.040",
          "value": "0.040"
        },
        "hide": 0,
        "label": "Storage",
        "name": "costStorageStandard",
        "options": [
          {
            "text": "0.040",
            "value": "0.040"
          }
        ],
        "query": "0.040",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": ".17",
          "value": ".17"
        },
        "hide": 0,
        "label": "SSD",
        "name": "costStorageSSD",
        "options": [
          {
            "text": ".17",
            "value": ".17"
          }
        ],
        "query": ".17",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": ".12",
          "value": ".12"
        },
        "hide": 0,
        "label": "Egress",
        "name": "costEgress",
        "options": [
          {
            "selected": true,
            "text": ".12",
            "value": ".12"
          }
        ],
        "query": ".12",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "text": "30",
          "value": "30"
        },
        "hide": 0,
        "label": "Discount",
        "name": "costDiscount",
        "options": [
          {
            "text": "30",
            "value": "30"
          }
        ],
        "query": "30",
        "queryValue": "",
        "skipUrlSync": false,
        "type": "constant"
      },
      {
        "current": {
          "selected": false,
          "text": "Prometheus",
          "value": "Prometheus"
        },
        "hide": 0,
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
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {
    "hidden": false,
    "refresh_intervals": [
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
  "timezone": "browser",
  "title": "Kubecost / Cluster cost & utilization",
  "uid": "cluster-costs",
  "version": 1
};

local configmap(me) = grafana.dashboard(me, 'kubecost-cluster-cost-utilization-metrics', dashboardConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
  ]
)

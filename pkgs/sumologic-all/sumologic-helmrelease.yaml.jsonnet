local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'true',
    },
    name: 'sumologic-fluentd',
    namespace: 'sumologic',
  },
  spec: {
    chart: {
      name: 'sumologic-fluentd',
      repository: 'https://sumologic.github.io/sumologic-kubernetes-collection',
      version: '0.8.0',
    },
    releaseName: 'collection',
    deployment: {
      replicaCount: 3,
      resources: {
        limits: {
          cpu: 1,
          memory: '1Gi',
        },
        requests: {
          cpu: 0.5,
          memory: '768Mi',
        },
      },
    },
    eventsDeployment: {
      resources: {
        limits: {
          cpu: '100m',
          memory: '256Mi',
        },
        requests: {
          cpu: '100m',
          memory: '256Mi',
        },
      },
    },
    falco: {
      enabled: true,
      falco: {
        jsonOutput: true,
      },
    },
    'fluent-bit': {
      backend: {
        forward: {
          host: 'collection-sumologic.sumologic.svc.cluster.local',
          port: 24321,
          shared_key: null,
          tls: 'off',
          tls_debug: 1,
          tls_verify: 'on',
        },
        type: 'forward',
      },
      enabled: true,
      input: {
        systemd: {
          enabled: true,
        },
      },
      metrics: {
        enabled: true,
      },
      rawConfig: |||
        @INCLUDE fluent-bit-service.conf

        [INPUT]
          Name             tail
          Path             /var/log/containers/*.log
          Parser           docker
          Tag              containers.*
          Refresh_Interval 1
          Rotate_Wait      60
          Mem_Buf_Limit    5MB
          Skip_Long_Lines  On
          DB               /tail-db/tail-containers-state.db
          DB.Sync          Normal
        [INPUT]
          Name            systemd
          Tag             host.*
          Systemd_Filter  _SYSTEMD_UNIT=addon-config.service
          Systemd_Filter  _SYSTEMD_UNIT=addon-run.service
          Systemd_Filter  _SYSTEMD_UNIT=cfn-etcd-environment.service
          Systemd_Filter  _SYSTEMD_UNIT=cfn-signal.service
          Systemd_Filter  _SYSTEMD_UNIT=clean-ca-certificates.service
          Systemd_Filter  _SYSTEMD_UNIT=containerd.service
          Systemd_Filter  _SYSTEMD_UNIT=coreos-metadata.service
          Systemd_Filter  _SYSTEMD_UNIT=coreos-setup-environment.service
          Systemd_Filter  _SYSTEMD_UNIT=coreos-tmpfiles.service
          Systemd_Filter  _SYSTEMD_UNIT=dbus.service
          Systemd_Filter  _SYSTEMD_UNIT=docker.service
          Systemd_Filter  _SYSTEMD_UNIT=efs.service
          Systemd_Filter  _SYSTEMD_UNIT=etcd-member.service
          Systemd_Filter  _SYSTEMD_UNIT=etcd.service
          Systemd_Filter  _SYSTEMD_UNIT=etcd2.service
          Systemd_Filter  _SYSTEMD_UNIT=etcd3.service
          Systemd_Filter  _SYSTEMD_UNIT=etcdadm-check.service
          Systemd_Filter  _SYSTEMD_UNIT=etcdadm-reconfigure.service
          Systemd_Filter  _SYSTEMD_UNIT=etcdadm-save.service
          Systemd_Filter  _SYSTEMD_UNIT=etcdadm-update-status.service
          Systemd_Filter  _SYSTEMD_UNIT=flanneld.service
          Systemd_Filter  _SYSTEMD_UNIT=format-etcd2-volume.service
          Systemd_Filter  _SYSTEMD_UNIT=kube-node-taint-and-uncordon.service
          Systemd_Filter  _SYSTEMD_UNIT=kubelet.service
          Systemd_Filter  _SYSTEMD_UNIT=ldconfig.service
          Systemd_Filter  _SYSTEMD_UNIT=locksmithd.service
          Systemd_Filter  _SYSTEMD_UNIT=logrotate.service
          Systemd_Filter  _SYSTEMD_UNIT=lvm2-monitor.service
          Systemd_Filter  _SYSTEMD_UNIT=mdmon.service
          Systemd_Filter  _SYSTEMD_UNIT=nfs-idmapd.service
          Systemd_Filter  _SYSTEMD_UNIT=nfs-mountd.service
          Systemd_Filter  _SYSTEMD_UNIT=nfs-server.service
          Systemd_Filter  _SYSTEMD_UNIT=nfs-utils.service
          Systemd_Filter  _SYSTEMD_UNIT=node-problem-detector.service
          Systemd_Filter  _SYSTEMD_UNIT=ntp.service
          Systemd_Filter  _SYSTEMD_UNIT=oem-cloudinit.service
          Systemd_Filter  _SYSTEMD_UNIT=rkt-gc.service
          Systemd_Filter  _SYSTEMD_UNIT=rkt-metadata.service
          Systemd_Filter  _SYSTEMD_UNIT=rpc-idmapd.service
          Systemd_Filter  _SYSTEMD_UNIT=rpc-mountd.service
          Systemd_Filter  _SYSTEMD_UNIT=rpc-statd.service
          Systemd_Filter  _SYSTEMD_UNIT=rpcbind.service
          Systemd_Filter  _SYSTEMD_UNIT=set-aws-environment.service
          Systemd_Filter  _SYSTEMD_UNIT=system-cloudinit.service
          Systemd_Filter  _SYSTEMD_UNIT=systemd-timesyncd.service
          Systemd_Filter  _SYSTEMD_UNIT=update-ca-certificates.service
          Systemd_Filter  _SYSTEMD_UNIT=user-cloudinit.service
          Systemd_Filter  _SYSTEMD_UNIT=var-lib-etcd2.service
          Max_Entries     1000
          Read_From_Tail  true

        @INCLUDE fluent-bit-output.conf
      |||,
      tolerations: [
        {
          effect: 'NoSchedule',
          operator: 'Exists',
        },
      ],
      trackOffsets: true,
    },
    fullnameOverride: '',
    image: {
      pullPolicy: 'IfNotPresent',
      repository: 'sumologic/kubernetes-fluentd',
      tag: '0.8.0',
    },
    nameOverride: '',
    'prometheus-operator': {
      alertmanager: {
        enabled: false,
      },
      enabled: true,
      grafana: {
        defaultDashboardsEnabled: false,
        enabled: false,
      },
      prometheus: {
        additionalServiceMonitors: [
          {
            additionalLabels: {
              app: 'collection-sumologic',
            },
            endpoints: [
              {
                port: 'metrics',
              },
            ],
            name: 'collection-sumologic',
            namespaceSelector: {
              matchNames: [
                'sumologic',
              ],
            },
            selector: {
              matchLabels: {
                app: 'collection-sumologic',
              },
            },
          },
          {
            additionalLabels: {
              app: 'collection-sumologic-events',
            },
            endpoints: [
              {
                port: 'metrics',
              },
            ],
            name: 'collection-sumologic-events',
            namespaceSelector: {
              matchNames: [
                'sumologic',
              ],
            },
            selector: {
              matchLabels: {
                app: 'collection-sumologic-events',
              },
            },
          },
          {
            additionalLabels: {
              app: 'collection-fluent-bit',
            },
            endpoints: [
              {
                path: '/api/v1/metrics/prometheus',
                port: 'metrics',
              },
            ],
            name: 'collection-fluent-bit',
            namespaceSelector: {
              matchNames: [
                'sumologic',
              ],
            },
            selector: {
              matchLabels: {
                app: 'fluent-bit',
              },
            },
          },
        ],
        prometheusSpec: {
          externalLabels: {
            cluster: config.cluster.metadata.name,
          },
          remoteWrite: [
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.statefulset',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_statefulset_status_(?:observed_generation|replicas)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.statefulset',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_statefulset_(?:replicas|metadata_generation)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.daemonset',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_daemonset_status_(?:current_number_scheduled|desired_number_scheduled|number_misscheduled|number_unavailable)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.daemonset',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_daemonset_metadata_generation',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.deployment',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_deployment_(?:metadata_generation|spec_paused|spec_replicas|spec_strategy_rollingupdate_max_unavailable)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.deployment',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_deployment_status_(?:replicas_available|observed_generation|replicas_unavailable)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_node_(?:info|spec_unschedulable|status_allocatable|status_capacity|status_condition)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.pod',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_pod_container_(?:info|resource_requests|resource_limits|status_ready|status_terminated_reason|status_waiting_reason|status_restarts_total)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.state.pod',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-state-metrics;kube_pod_status_phase',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.controller-manager',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kubelet;cloudprovider_.*_api_request_duration_seconds.*',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.scheduler',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kube-scheduler;scheduler_(?:e2e_scheduling|binding|scheduling_algorithm)_latency_microseconds.*',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.apiserver',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'apiserver;apiserver_request_(?:count|latencies.*)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.apiserver',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'apiserver;etcd_request_cache_(?:get|add)_latencies_summary.*',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.apiserver',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'apiserver;etcd_helper_cache_(?:hit|miss)_count',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.kubelet',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kubelet;kubelet_docker_operations_(?:errors|latency_microseconds.*)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.kubelet',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'kubelet;kubelet_(running_container_count|running_pod_count|runtime_operations_latency_microseconds.*)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.container',
              writeRelabelConfigs: [
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container',
                  ],
                },
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container_name',
                  ],
                },
                {
                  action: 'keep',
                  regex: 'kubelet;container_cpu_(?:load_average_10s|(?:system|usage|cfs_throttled)_seconds_total)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.container',
              writeRelabelConfigs: [
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container',
                  ],
                },
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container_name',
                  ],
                },
                {
                  action: 'keep',
                  regex: 'kubelet;container_memory_(?:usage_bytes|swap|working_set_bytes)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.container',
              writeRelabelConfigs: [
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container',
                  ],
                },
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container_name',
                  ],
                },
                {
                  action: 'keep',
                  regex: 'kubelet;container_spec_memory_(?:|swap_|reservation_)limit_bytes',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.container',
              writeRelabelConfigs: [
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container',
                  ],
                },
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container_name',
                  ],
                },
                {
                  action: 'keep',
                  regex: 'kubelet;container_spec_cpu_(?:|quota|period)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.container',
              writeRelabelConfigs: [
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container',
                  ],
                },
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container_name',
                  ],
                },
                {
                  action: 'keep',
                  regex: 'kubelet;container_fs_(?:(?:usage|limit)_bytes|(?:reads|writes)_bytes_total)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.container',
              writeRelabelConfigs: [
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container',
                  ],
                },
                {
                  action: 'drop',
                  regex: 'POD',
                  sourceLabels: [
                    'container_name',
                  ],
                },
                {
                  action: 'keep',
                  regex: 'kubelet;container_network_(?:receive|transmit)_(?:bytes|errors|packets_dropped)_total',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_load(?:1|5|15)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_cpu_seconds_total',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_memory_(?:MemAvailable|MemTotal|Buffers|SwapCached|Cached|MemFree|SwapFree)_bytes',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_ipvs_(?:incoming|outgoing)_(?:bytes|packets)_total',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_disk_(?:(?:reads|writes)_completed|(?:read|written)_bytes)_total',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_filesystem_(?:avail|free|size)_bytes',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.node',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node-exporter;node_filesystem_(?:files)',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'apiserver;cluster_quantile:apiserver_request_latencies:histogram_quantile',
                  sourceLabels: [
                    'job',
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'instance:node_(?:cpu|filesystem_usage|network_receive_bytes|node_network_transmit_bytes):rate:sum',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'instance:node_cpu:ratio|cluster:node_cpu:sum_rate5m|cluster:node_cpu:ratio',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'cluster_quantile:scheduler_(?:e2e_scheduling|scheduling_algorithm|binding)_latency:histogram_quantile',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node_namespace_pod:kube_pod_info:|:kube_pod_info_node_count:',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node:node_num_cpu:sum|:node_cpu_utilisation:avg1m|node:node_cpu_utilisation:avg1m|node:cluster_cpu_utilisation:ratio|:node_cpu_saturation_load1:|node:node_cpu_saturation_load1:',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: ':node_memory_utilisation:|:node_memory_MemFreeCachedBuffers_bytes:sum|:node_memory_MemTotal_bytes:sum|node:node_memory_bytes_available:sum|node:node_memory_bytes_total:sum|node:node_memory_utilisation:ratio|node:cluster_memory_utilisation:ratio|:node_memory_swap_io_bytes:sum_rate|node:node_memory_utilisation:|node:node_memory_utilisation_2:|node:node_memory_swap_io_bytes:sum_rate',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: ':node_disk_utilisation:avg_irate|node:node_disk_utilisation:avg_irate|:node_disk_saturation:avg_irate|node:node_disk_saturation:avg_irate',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node:node_filesystem_usage:|node:node_filesystem_avail:',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: ':node_net_utilisation:sum_irate|node:node_net_utilisation:sum_irate|:node_net_saturation:sum_irate|node:node_net_saturation:sum_irate',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics.operator.rule',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'node:node_inodes_total:|node:node_inodes_free:',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'up',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'prometheus_remote_storage_.*',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'fluentd_.*',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
            {
              url: 'http://collection-sumologic.sumologic.svc.cluster.local:9888/prometheus.metrics',
              writeRelabelConfigs: [
                {
                  action: 'keep',
                  regex: 'fluentbit.*',
                  sourceLabels: [
                    '__name__',
                  ],
                },
              ],
            },
          ],
        },
      },
    },
    sumologic: {
      addStream: 'true',
      addTime: 'true',
      addTimestamp: 'true',
      chunkLimitSize: '100k',
      clusterName: config.cluster.metadata.name,
      concatSeparator: '',
      eventCollectionEnabled: true,
      excludeContainerRegex: '',
      excludeHostRegex: '',
      excludeNamespaceRegex: '',
      excludePodRegex: '',
      flushInterval: '5s',
      k8sMetadataFilter: {
        bearerCacheSize: '1000',
        bearerCacheTtl: '3600',
        verifySsl: 'true',
        watch: 'true',
      },
      kubernetesMeta: 'true',
      kubernetesMetaReduce: 'false',
      logFormat: 'fields',
      multilineStartRegexp: '/^\\w{3} \\d{1,2}, \\d{4}/',
      numThreads: 4,
      setupEnabled: true,
      sourceCategory: '%{namespace}/%{pod_name}',
      sourceCategoryPrefix: 'kubernetes/',
      sourceCategoryReplaceDash: '/',
      sourceName: '%{namespace}.%{pod}.%{container}',
      timestampKey: 'timestamp',
      totalLimitSize: '128m',
      verifySsl: 'true',
    },
  },
};

function(config) helmrelease(config)

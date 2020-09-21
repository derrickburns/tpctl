local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'namespaces',
        'pods',
        'pods/logs',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
  ],
};

local daemonset(me) = k8s.daemonset(me,
                                    container={
                                      env: [
                                        k8s.envVar('AWS_REGION', me.config.cluster.metadata.region),
                                        k8s.envVar('REGION', me.config.cluster.metadata.region),
                                        k8s.envVar('CLUSTER_NAME', me.config.cluster.metadata.name),
                                      ],
                                      image: 'fluent/fluentd-kubernetes-daemonset:v1.9.2-debian-cloudwatch-1.0',
                                      name: me.pkg,
                                      resources: {
                                        limits: {
                                          memory: '300Mi',
                                        },
                                        requests: {
                                          cpu: '100m',
                                          memory: '200Mi',
                                        },
                                      },
                                      volumeMounts: [
                                        {
                                          mountPath: '/config-volume',
                                          name: 'config-volume',
                                        },
                                        {
                                          mountPath: '/fluentd/etc',
                                          name: 'fluentdconf',
                                        },
                                        {
                                          mountPath: '/var/log',
                                          name: 'varlog',
                                        },
                                        {
                                          mountPath: '/var/lib/docker/containers',
                                          name: 'varlibdockercontainers',
                                          readOnly: true,
                                        },
                                        {
                                          mountPath: '/run/log/journal',
                                          name: 'runlogjournal',
                                          readOnly: true,
                                        },
                                        {
                                          mountPath: '/var/log/dmesg',
                                          name: 'dmesg',
                                          readOnly: true,
                                        },
                                      ],
                                    },
                                    volumes=[
                                      {
                                        configMap: {
                                          name: me.pkg,
                                        },
                                        name: 'config-volume',
                                      },
                                      {
                                        emptyDir: {},
                                        name: 'fluentdconf',
                                      },
                                      {
                                        hostPath: {
                                          path: '/var/log',
                                        },
                                        name: 'varlog',
                                      },
                                      {
                                        hostPath: {
                                          path: '/var/lib/docker/containers',
                                        },
                                        name: 'varlibdockercontainers',
                                      },
                                      {
                                        hostPath: {
                                          path: '/run/log/journal',
                                        },
                                        name: 'runlogjournal',
                                      },
                                      {
                                        hostPath: {
                                          path: '/var/log/dmesg',
                                        },
                                        name: 'dmesg',
                                      },
                                    ]) {

  initContainers: [
    {
      command: [
        'sh',
        '-c',
        'cp /config-volume/..data/* /fluentd/etc',
      ],
      image: 'busybox:1.31.1',
      name: 'copy-fluentd-config',
      volumeMounts: [
        {
          mountPath: '/config-volume',
          name: 'config-volume',
        },
        {
          mountPath: '/fluentd/etc',
          name: 'fluentdconf',
        },
      ],
    },
    {
      command: [
        'sh',
        '-c',
        '',
      ],
      image: 'busybox:1.31.1',
      name: 'update-log-driver',
    },
  ],
  spec+: {
    template+: {
      spec+: {
        securityContext: {
          fsGroup: 65534,
        },
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 30,
      },
    },
  },
};

local configmap(me) = k8s.configmap(me) {
  data: {
    'fluent.conf': |||
      @include containers.conf
      @include systemd.conf
      @include host.conf

      <match fluent.**>
        @type null
      </match>
    |||,
    'containers.conf': |||
      <source>
        @type tail
        @id in_tail_container_logs
        @label @containers
        path /var/log/containers/*.log
        pos_file /var/log/fluentd-containers.log.pos
        tag *
        read_from_head true
        <parse>
          @type json
          time_format %Y-%m-%dT%H:%M:%S.%NZ
        </parse>
      </source>
       
      <label @containers>
        <filter **>
          @type kubernetes_metadata
          @id filter_kube_metadata
        </filter>
        
        <filter **>
          @type record_transformer
          @id filter_containers_stream_transformer
          <record>
            stream_name ${tag_parts[3]}
          </record>
        </filter>
        
        <match **>
          @type cloudwatch_logs
          @id out_cloudwatch_logs_containers
          region "#{ENV.fetch('REGION')}"
          log_group_name "/aws/containerinsights/#{ENV.fetch('CLUSTER_NAME')}/application"
          log_stream_name_key stream_name
          remove_log_stream_name_key true
          auto_create_stream true
          <buffer>
            flush_interval 5
            chunk_limit_size 2m
            queued_chunks_limit_size 32
            retry_forever true
          </buffer>
        </match>
      </label>
    |||,
    'systemd.conf': |||
      <source>
        @type systemd
        @id in_systemd_kubelet
        @label @systemd
        filters [{ "_SYSTEMD_UNIT": "kubelet.service" }]
        <entry>
          field_map {"MESSAGE": "message", "_HOSTNAME": "hostname", "_SYSTEMD_UNIT": "systemd_unit"}
          field_map_strict true
        </entry>
        path /var/log/journal
        pos_file /var/log/fluentd-journald-kubelet.pos
        read_from_head true
        tag kubelet.service
      </source>

      <source>
        @type systemd
        @id in_systemd_kubeproxy
        @label @systemd
        filters [{ "_SYSTEMD_UNIT": "kubeproxy.service" }]
        <entry>
          field_map {"MESSAGE": "message", "_HOSTNAME": "hostname", "_SYSTEMD_UNIT": "systemd_unit"}
          field_map_strict true
        </entry>
        path /var/log/journal
        pos_file /var/log/fluentd-journald-kubeproxy.pos
        read_from_head true
        tag kubeproxy.service
      </source>

      <source>
        @type systemd
        @id in_systemd_docker
        @label @systemd
        filters [{ "_SYSTEMD_UNIT": "docker.service" }]
        <entry>
          field_map {"MESSAGE": "message", "_HOSTNAME": "hostname", "_SYSTEMD_UNIT": "systemd_unit"}
          field_map_strict true
        </entry>
        path /var/log/journal
        pos_file /var/log/fluentd-journald-docker.pos
        read_from_head true
        tag docker.service
      </source>

      <label @systemd>
        <filter **>
          @type kubernetes_metadata
          @id filter_kube_metadata_systemd
        </filter>
        
        <filter **>
          @type record_transformer
          @id filter_systemd_stream_transformer
          <record>
            stream_name ${tag}-${record["hostname"]}
          </record>
        </filter>
        
        <match **>
          @type cloudwatch_logs
          @id out_cloudwatch_logs_systemd
          region "#{ENV.fetch('REGION')}"
          log_group_name "/aws/containerinsights/#{ENV.fetch('CLUSTER_NAME')}/dataplane"
          log_stream_name_key stream_name
          auto_create_stream true
          remove_log_stream_name_key true
          <buffer>
            flush_interval 5
            chunk_limit_size 2m
            queued_chunks_limit_size 32
            retry_forever true
          </buffer>
        </match>
      </label>
    |||,
    'host.conf': |||
      <source>
        @type tail
        @id in_tail_dmesg
        @label @hostlogs
        path /var/log/dmesg
        pos_file /var/log/dmesg.log.pos
        tag host.dmesg
        read_from_head true
        <parse>
          @type syslog
        </parse>
      </source>

      <source>
        @type tail
        @id in_tail_secure
        @label @hostlogs
        path /var/log/secure
        pos_file /var/log/secure.log.pos
        tag host.secure
        read_from_head true
        <parse>
          @type syslog
        </parse>
      </source>

      <source>
        @type tail
        @id in_tail_messages
        @label @hostlogs
        path /var/log/messages
        pos_file /var/log/messages.log.pos
        tag host.messages
        read_from_head true
        <parse>
          @type syslog
        </parse>
      </source>

      <label @hostlogs>
        <filter **>
          @type kubernetes_metadata
          @id filter_kube_metadata_host
        </filter>
        
        <filter **>
          @type record_transformer
          @id filter_containers_stream_transformer_host
          <record>
            stream_name ${tag}-${record["host"]}
          </record>
        </filter>
        
        <match host.**>
          @type cloudwatch_logs
          @id out_cloudwatch_logs_host_logs
          region "#{ENV.fetch('REGION')}"
          log_group_name "/aws/containerinsights/#{ENV.fetch('CLUSTER_NAME')}/host"
          log_stream_name_key stream_name
          remove_log_stream_name_key true
          auto_create_stream true
          <buffer>
            flush_interval 5
            chunk_limit_size 2m
            queued_chunks_limit_size 32
            retry_forever true
          </buffer>
        </match>
      </label>
    |||,
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
    clusterrole(me),
    k8s.clusterrolebinding(me),
    daemonset(me),
  ]
)

local configmap(config, namespace) = {
  apiVersion: 'v1',
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
  kind: 'ConfigMap',
  metadata: {
    labels: {
      'k8s-app': 'fluentd-cloudwatch',
    },
    name: 'fluentd-config',
    namespace: 'amazon-cloudwatch',
  },
};

function(config, prev, namespace, pkg) configmap(config, namespace)

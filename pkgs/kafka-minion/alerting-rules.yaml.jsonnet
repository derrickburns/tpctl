local common = import '../../lib/common.jsonnet';
local prometheus = import '../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'kafka.rules',
    rules: [
      {
        alert: 'KafkaTopicPartitionLagging',
        annotations: {
          summary: 'Kafka partition is lagging behind.',
          description: 'The Kafka partition `{{ $labels.partition }}/{{ $labels.topic }}` lag is above 10 for the past 15 minutes.',
          dashboard_url: 'https://grafana.%s/d/0BVsKYrmkk/kafka-minion?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'sum (kafka_minion_group_topic_partition_lag{topic=~".*-user-events$"}) by (topic, partition) > 10',
        'for': '15m',
        labels: {
          severity: 'warning',
        },
      },
      {
        alert: 'KafkaDeadLetterMessageProduced',
        annotations: {
          summary: 'Kafka dead letter message was produced.',
          description: 'The Kafka dead letter topic `{{ $labels.topic }}` produced more than 1 message the last 10 minutes.',
          dashboard_url: 'https://grafana.%s/d/4Gjz6B4Zz/kafka-minion-ops?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(increase(kafka_minion_topic_partition_message_count{topic=~".*-dl$"}[10m])) by (topic) > 1',
        labels: {
          severity: 'warning',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'kafka', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)

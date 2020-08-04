local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'cert-manager.rules',
    rules: [
      {
        alert: 'CertManagerExpiringCertificate',
        annotations: {
          message: 'The certificate {{ $labels.name }} in the namespace {{ $labels.exported_namespace }} is expiring within 2 weeks.',
          dashboard: 'https://grafana.%s/d/u6M5igpWk/cert-manager?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'certmanager_certificate_expiration_timestamp_seconds - time() < 1814400',
        'for': '30s',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'CertManagerCertificateNotReady',
        annotations: {
          message: 'The certificate {{ $labels.name }} in the namespace {{ $labels.exported_namespace }} is not ready.',
          dashboard: 'https://grafana.%s/d/u6M5igpWk/cert-manager?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'certmanager_certificate_ready_status{condition="False"} > 0',
        'for': '10m',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'cert-manager', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
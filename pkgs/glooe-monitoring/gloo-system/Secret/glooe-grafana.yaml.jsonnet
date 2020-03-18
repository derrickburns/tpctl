local secret(namespace) = {
  apiVersion: 'v1',
  data: {
    'admin-password': 'dGlkZXBvb2w=',
    'admin-user': 'YWRtaW4=',
    'ldap-toml': '',
  },
  kind: 'Secret',
  metadata: {
    labels: {
      app: 'glooe-grafana',
      chart: 'grafana-4.0.1',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-grafana',
    namespace: namespace,
  },
  type: 'Opaque',
};

function(config, prev, namespace, pkg) secret(namespace)

local secret(namespace) = {
local common = import '../../lib/common.jsonnet';
  apiVersion: 'v1',
  data: {
    Scheme: std.base64('mongodb'),
    Addresses: std.base64('mongodb'),
    Username: '',
    Password: '',
    Database: '',
    Tls: std.base64('false'),
    OptParams: '',
  },
  kind: 'Secret',
  metadata: {
    name: 'mongo',
    namespace: namespace,
  },
  type: 'Opaque',
};

function(config, prev, namespace, pkg) secret(namespace)

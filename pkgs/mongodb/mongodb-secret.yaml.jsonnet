local common = import '../../lib/common.jsonnet';

local secret(me) = k8s.k('v1', 'Secret') + k8s.metadata('mongo', me.namespace) {
  data+: {
    Scheme: std.base64('mongodb'),
    Addresses: std.base64('mongodb'),
    Username: '',
    Password: '',
    Database: '',
    Tls: std.base64('false'),
    OptParams: '',
  },
  kind: 'Secret',
  type: 'Opaque',
};

function(config, prev, namespace, pkg) secret(common.package(config, prev, namespace, pkg))

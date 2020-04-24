local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/clinic-report:latest',
    env: [
      k8s.envSecret('SALT_DEPLOY', 'userdata', 'UserIdSalt'),
      k8s.envSecret('MONGO_SCHEME', 'mongo', 'Scheme'),
      k8s.envSecret('MONGO_USERNAME', 'mongo', 'Username'),
      k8s.envSecret('MONGO_PASSWORD', 'mongo', 'Password'),
      k8s.envSecret('MONGO_ADDRESSES', 'mongo', 'Addresses'),
      k8s.envSecret('MONGO_OPT_PARAMS', 'mongo', 'OptParams'),
      k8s.envSecret('MONGO_SSL', 'mongo', 'Tls'),
      k8s.envVar('MONGO_DATABASE', 'user'),
    ],
    ports: [
      {
        containerPort: 27017,
      },
    ],
  },
  spec+: {
    template+: {
      spec+: {
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

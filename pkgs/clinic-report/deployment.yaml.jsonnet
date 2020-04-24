local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/clinic-report:latest',
    _env:: {
      SALT_DEPLOY: k8s._envSecret('userdata', 'UserIdSalt'),
      MONGO_SCHEME: k8s._envSecret('mongo', 'Scheme'),
      MONGO_USERNAME: k8s._envSecret('mongo', 'Username'),
      MONGO_PASSWORD: k8s._envSecret('mongo', 'Password'),
      MONGO_ADDRESSES: k8s._envSecret('mongo', 'Addresses'),
      MONGO_OPT_PARAMS: k8s._envSecret('mongo', 'OptParams'),
      MONGO_SSL: k8s._envSecret('mongo', 'Tls'),
      MONGO_DATABASE: { value: 'user' },
    },
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

local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local deployment(me) = k8s.deployment(me) + flux.metadata() {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            image: 'tidepool/clinic-report:latest',
            imagePullPolicy: 'Always',
            name: me.pkg,
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
        ],
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

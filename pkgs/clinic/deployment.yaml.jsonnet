local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: [
    {
      image: 'tidepool/clinic:latest',
      imagePullPolicy: 'Always',
      name: me.pkg,
      env: [
        k8s.envSecret('TIDEPOOL_STORE_SCHEME', 'mongo', 'Scheme'),
        k8s.envSecret('TIDEPOOL_STORE_USERNAME', 'mongo', 'Username'),
        k8s.envSecret('TIDEPOOL_STORE_PASSWORD', 'mongo', 'Password'),
        k8s.envSecret('TIDEPOOL_STORE_ADDRESSES', 'mongo', 'Addresses'),
        k8s.envSecret('TIDEPOOL_STORE_OPT_PARAMS', 'mongo', 'OptParams'),
        k8s.envSecret('TIDEPOOL_STORE_TLS', 'mongo', 'Tls'),
        k8s.envVar('TIDEPOOL_STORE_DATABASE', 'clinic'),
      ],
    },
  ],
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

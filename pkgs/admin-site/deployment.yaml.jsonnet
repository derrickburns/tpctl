local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  metadata+: {
    annotations+: {
      'fluxcd.io/automated': 'true',
      ['fluxcd.io/tag.%s' % me.pkg]: 'glob:master-*',
    },
  },
  spec+: {
    template+: {
      spec+: {
        containers: [{
          name: me.pkg,
          image: 'tidepool/admin-site:latest',
          imagePullPolicy: 'Always',
          ports: [{
            containerPort: 8080,
          }],
        }],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(lib.package(config, namespace, pkg))
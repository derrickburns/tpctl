local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(config, prev, me) = k8s.deployment(me) {
  metadata+: {
    annotations: {
      'fluxcd.io/automated': 'true',
      'fluxcd.io/tag.mongoproxy': 'glob:master-*',
    },
  },
  spec+: {
    template+: {
      spec+: {
        local containers = lib.getElse(prev, 'spec.template.spec.containers', []),
        local image = if containers == [] then 'tidepool/mongoproxy:latest' else containers[0].image,
        containers: [
          {
            name: 'mongoproxy',
            image: image,
            imagePullPolicy: 'IfNotPresent',
            ports: [{
              containerPort: 27017,
            }],
            env: [
              me.envSecret('MONGO_SCHEME', me.pkg, 'Scheme'),
              me.envSecret('MONGO_ADDRESSES', me.pkg, 'Addresses'),
              me.envSecret('MONGO_USERNAME', me.pkg, 'Username'),
              me.envSecret('MONGO_PASSWORD', me.pkg, 'Password'),
              me.envSecret('MONGO_DATABASE', me.pkg, 'Database'),
              me.envSecret('MONGO_OPT_PARAMS', me.pkg, 'OptParams'),
              me.envSecret('MONGO_TLS', me.pkg, 'Tls'),
              me.envSecret('MONGO_TIMEOUT', me.pkg, 'Timeout'),
              me.envSecret('MONGO_READONLY', me.pkg, 'Readonly'),
              me.envVar('MONGOPROXY_PORT', '27017'),
            ],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(config, prev, lib.package(config, namespace, pkg))

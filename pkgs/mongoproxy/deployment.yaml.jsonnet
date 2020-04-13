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
              {
                name: 'MONGO_SCHEME',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Scheme',
                  },
                },
              },
              {
                name: 'MONGO_ADDRESSES',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Addresses',
                  },
                },
              },
              {
                name: 'MONGO_USERNAME',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Username',
                  },
                },
              },
              {
                name: 'MONGO_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Password',
                  },
                },
              },
              {
                name: 'MONGO_DATABASE',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Database',
                  },
                },
              },
              {
                name: 'MONGO_OPT_PARAMS',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'OptParams',
                  },
                },
              },
              {
                name: 'MONGO_TLS',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Tls',
                  },
                },
              },
              {
                name: 'MONGOPROXY_TIMEOUT',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Timeout',
                  },
                },
              },
              {
                name: 'MONGOPROXY_READONLY',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mongoproxy',
                    key: 'Readonly',
                  },
                },
              },
              {
                name: 'MONGOPROXY_PORT',
                value: '27017',
              },
            ],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(config, prev, lib.package(config, namespace, pkg))

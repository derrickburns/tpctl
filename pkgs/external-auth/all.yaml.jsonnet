local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local port = 8080;
local containerPort = 4000;

local getPrev(me, this, def='') = (
  local default = (if def == '' then 'tidepool/%s:latest' % me.pkg else def);
  local prev = std.trace( std.manifestJson({ meprev: me.prev, this: this }),  k8s.findMatch(me.prev, this));
  local containers = lib.getElse(prev, 'spec.template.spec.containers', []);
  if std.length(containers) < 1
  then default
  else lib.getElse(containers[0], 'image', default)
);

local deployment(me) = k8s.deployment(me) + flux.metadata() {
  local this = self,
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            image: getPrev(me, this),
            imagePullPolicy: 'Always',
            name: me.pkg,
            env: [k8s.envSecret('API_SECRET', 'shoreline', 'ServiceAuth')],
            ports: [{ containerPort: containerPort }],
          },
        ],
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(port, containerPort)],
  },
};

local upstream(me) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata(me.pkg, me.namespace) {
  spec+: {
    static: {
      hosts: [
        {
          addr: '%s.%s.svc.cluster.local' % [me.pkg, me.namespace],
          port: port,
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    upstream(me),
    deployment(me),
  ]
)

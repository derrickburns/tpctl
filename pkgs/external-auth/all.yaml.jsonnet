local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';

local servicePort = 8080;
local containerPort = 4000;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/%s:latest' % me.pkg,
    imagePullPolicy: 'Always',
    env: [k8s.envSecret('API_SECRET', 'shoreline', 'ServiceAuth')],
    ports: [{ containerPort: containerPort }],
  },
  spec+: {
    template+: linkerd.metadata(me, true),
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(servicePort, containerPort)],
  },
};

local upstream(me) = gloo.upstream(me) {
  spec+: {
    static: {
      hosts: [
        {
          addr: '%s.%s.svc.cluster.local' % [me.pkg, me.namespace],
          port: servicePort,
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

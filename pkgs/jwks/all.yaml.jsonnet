local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local servicePort = 80;
local containerPort = 80;

local deployment(me) = flux.deployment(
  me,
  containers={
    image: 'nginx',
    ports: [{
      containerPort: containerPort,
    }],
    volumeMounts: [{
      mountPath: '/usr/share/nginx/html',
      name: me.pkg,
    }],
  },
  volumes=[{
    configMap: {
      name: me.pkg,
    },
    name: me.pkg,
  }]
);


local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(servicePort, containerPort)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    gloo.kubeupstream(me, servicePort),
  ]
)

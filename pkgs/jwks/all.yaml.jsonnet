local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local servicePort = 80;
local containerPort = 80;

local deployment(me) = flux.deployment(me) {
  _containers:: [{
    image: 'nginx',
    ports: [{
      containerPort: containerPort,
    }],
    volumeMounts: [{
      mountPath: /usr/share/nginx/html
      name: me.pkg,
    }],
  }],
  spec+: {
    template+: {
      spec+: {
        volumes: [{
          configMap: {
            name: me.pkg,
          },
          name: me.pkg,
        }],
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(servicePort, containerPort)],
  },
};

local upstream(me) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata(me.pkg, me.namespace) {
  spec+: {
    kube+: {
      selector: {}
      serviceName: me.pkg,
      serviceNamespace:  me.namespace,
      servicePort: servicePort,
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    upstream(me),
  ]
)

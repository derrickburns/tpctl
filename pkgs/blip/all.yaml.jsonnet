local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    name: me.pkg,
    image: 'tidepool/blip:master-latest',
    env: [
      k8s.envVar('SKIP_HAKKEN', 'true'),
      k8s.envVar('WEBPACK_PUBLIC_PATH', me.deployment.webpackPublicPath),
      k8s.envVar('WEBPACK_DEVTOOL', me.deployment.webpackDevTool),
      k8s.envVar('WEBPACK_DEVTOOL_VIZ', me.deployment.webpackDevToolViz),
      k8s.envVar('DEV_TOOLS', 'false'),
      k8s.envVar('API_HOST', me.deployment.apiHost),
    ],
    ports:
      [{ containerPort: tidepool.ports.blip }] +
      [{ containerPort: port } for port in lib.values(me.deployments.ports.viz)],
  },
  spec: {
    template: {
      spec: {
        initContainers: [tidepool.shoreline_init_container],
      },
    },
  },
}, me.deployment.values);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(tidepool.ports.blip, tidepool.ports.blip)] +
           [k8s.port(e.port, e.port, 'http-viz-%s' % e.name) for e in me.deployments.ports.viz],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

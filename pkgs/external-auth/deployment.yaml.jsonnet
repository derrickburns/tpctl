local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local getPrev(me, prev, def='') = (
  local default = (if def == '' then 'tidepool/%s:latest' % me.pkg else def);
  local containers = lib.getElse(prev, 'spec.template.spec.containers, []);
  if std.length(containers) < 1 
  then default
  else lib.getElse(containers[0], image, default)
);

local deployment(me) = k8s.deployment(me) + flux.metadata() {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            image: getPrev(me, prev),
            imagePullPolicy: 'Always',
            name: me.pkg,
            env: [k8s.envSecret('API_SECRET', 'shoreline', 'ServiceAuth')],
            ports: [{ containerPort: 4000 }],
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))

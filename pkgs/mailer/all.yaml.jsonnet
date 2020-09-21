local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local port = 8080;

local deployment(me) = flux.deployment(me,
                                       containers={
                                         image: 'tidepool/mailer:master-latest',
                                         env: [
                                           k8s.envVar('TIDEPOOL_WORKSCHEDULER_ADDRESS', 'email-scheduler:5051'),
                                           k8s.envVar('TIDEPOOL_MAILER_BACKEND', lib.getElse(me, 'mailer-backend', 'ses')),
                                           k8s.envVar('TIDEPOOL_SERVICE_PORT', std.toString(port)),
                                         ],
                                         ports: [{
                                           containerPort: port,
                                         }],
                                       },
                                       serviceAccount=true) {
  spec+: {
    template+: {
      spec+: {
        securityContext: {
          fsGroup: 65534,
        },
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      k8s.port(port, port),
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    deployment(me),
    service(me),
  ]
)

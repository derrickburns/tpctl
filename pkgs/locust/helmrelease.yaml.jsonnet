local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) =
  k8s.helmrelease(me, { git: 'git@github.com:tidepool-org/locust-helm' }) {
    spec+: {
      values+: {
        master: {
          config: {
            'target-host': 'http://internal',
          },
        },
      },
    },
  };

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

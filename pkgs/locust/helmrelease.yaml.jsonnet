local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, prev, me) =
  k8s.githelmrelease('locust', me.namespace, 'git@github.com:tidepool-org/locust-helm') {
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

function(config, prev, namespace, pkg) helmrelease(config, prev, lib.package(config, namespace, pkg))

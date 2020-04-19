local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local pod(me) = k8s.pod(me) {
  spec+: {
    containers: [
      {
        command: [
          'sleep',
          '3600',
        ],
        image: 'gcr.io/kubernetes-e2e-test-images/dnsutils:1.3',
        imagePullPolicy: 'IfNotPresent',
        name: me.pkg,
      },
    ],
    restartPolicy: 'Always',
  },
};

function(config, prev, namespace, pkg) pod(common.package(config, prev, namespace, pkg))

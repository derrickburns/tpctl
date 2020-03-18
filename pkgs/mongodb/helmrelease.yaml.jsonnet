local k8s=import '../../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = {
  "apiVersion": "helm.fluxcd.io/v1",
  "kind": "HelmRelease",
  "metadata": {
    "name": "mongo",
    "namespace": namespace,
  },
  "spec": {
    "chart": {
      "git": "git@github.com:tidepool-org/development",
      "path": "charts/mongo",
      "ref": "master"
    },
    "values": {
      mongodb: {
        seed: false,
        persistent: false,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, namespace)

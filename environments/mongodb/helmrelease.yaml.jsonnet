local helmrelease(config, namespace) {
  "apiVersion": "helm.fluxcd.io/v1",
  "kind": "HelmRelease",
  "metadata": {
    "name": "mongo"
    "namespace": namespace,
  },
  "spec": {
    "chart": {
      "git": "git@github.com:tidepool-org/development",
      "path": "charts/mongo",
      "ref": "develop"
    }
  }
};

function(config, prev, namespace) helmrelease(config, namespace)

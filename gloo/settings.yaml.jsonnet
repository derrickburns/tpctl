local settings(config) = {
  apiVersion: "gloo.solo.io/v1",
  kind: "Settings",
  metadata: {
    labels: {
      app: "gloo"
    },
    name: "default",
    namespace: config.pkgs.gloo.namespace,
  },
  spec: {
    gateway: {
      validation: {
        alwaysAccept: false,
      },
    },
    bindAddr: "0.0.0.0:9977",
    discovery: {
      fdsMode: "WHITELIST"
    },
    discoveryNamespace: config.pkgs.gloo.namespace,
    kubernetesArtifactSource: {},
    kubernetesConfigSource: {},
    kubernetesSecretSource: {},
    linkerd: true,
    refreshRate: "60s"
  }
};

function(config) settings(config)

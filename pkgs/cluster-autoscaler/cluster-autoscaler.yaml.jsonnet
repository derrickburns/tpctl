local helmrelease(config) = {
  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "true"
    },
    name: "cluster-autoscaler",
    namespace: "kube-system"
  },
  spec: {
    chart: {
      name: "cluster-autoscaler",
      repository: "https://kubernetes-charts.storage.googleapis.com/",
      version: "6.0.0"
    },
    releaseName: "cluster-autoscaler",
    values: {
      autoDiscovery: {
        clusterName: config.cluster.metadata.name,
      },
      awsRegion: config.cluster.metadata.region,
      extraArgs: {
        "ignore-daemonsets-utilization": "true",
        "scale-down-utilization-threshold": 0.6,
        "skip-nodes-with-local-storage": false,
        v: 5
      },
      image: {
        tag: "v1.16.1"
      },
      rbac: {
         create: true,
      },
    }
  }
};

function(config) helmrelease(config)

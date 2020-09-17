local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.9.1', repository: 'https://jupyterhub.github.io/helm-chart' } ) {
  spec+: {
    values: {
      singleuser: {
        serviceAccountName: "spark",
        image: {
          //name: "tidepool/jupyter-datascience-notebook",
          name: "jupyter/pyspark-notebook",
          tag: "latest"
        },
      },
      proxy: {
        secretToken: "7994c473966b6614690557a8e2e075a182cf485429b9dc84c92c55c2b9e9d312",
        service: {
          type: "ClusterIP"
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

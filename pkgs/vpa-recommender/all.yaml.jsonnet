local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local sa(me) = k8s.serviceaccount(me) {};

local deployment(me) = k8s.deployment(me,
                                      serviceAccount=true,
                                      containers={
                                        image: 'us.gcr.io/k8s-artifacts-prod/autoscaling/vpa-recommender:%s' % lib.getElse(me, 'version', '0.8.0'),
                                        args: [],
                                        // '--storage=prometheus',
                                        // '--prometheus-address=http://prometheus-operator-prometheus.monitoring:9090',
                                        // '--v=4',
                                        // '--prometheus-cadvisor-job-name=kubelet',
                                        // '--history-length=4d',

                                        ports: [{
                                          containerPort: 8080,
                                        }],
                                        resources: {
                                          requests: {
                                            cpu: '50m',
                                            memory: '500Mi',
                                          },
                                          limits: {
                                            cpu: '200m',
                                            memory: '1000Mi',
                                          },
                                          // requests: {
                                          // cpu: '300m',
                                          // memory: '2000Mi',
                                          // },
                                          // limits: {
                                          // cpu: '400m',
                                          // memory: '3000Mi',
                                          // },
                                        },
                                      }) {


  spec+: {
    template+: {
      spec+: {
        affinity: {
          nodeAffinity: k8s.nodeAffinity(),
        },
        tolerations: [k8s.toleration()],

      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    sa(me),
    deployment(me),
  ]
)

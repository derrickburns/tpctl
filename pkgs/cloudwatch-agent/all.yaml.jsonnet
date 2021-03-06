local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'pods',
        'nodes',
        'endpoints',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'apps',
      ],
      resources: [
        'replicasets',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'batch',
      ],
      resources: [
        'jobs',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'nodes/proxy',
      ],
      verbs: [
        'get',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'nodes/stats',
        'configmaps',
        'events',
      ],
      verbs: [
        'create',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resourceNames: [
        'cwagent-clusterleader',
      ],
      resources: [
        'configmaps',
      ],
      verbs: [
        'get',
        'update',
      ],
    },
  ],
};

local clusterrolebinding(me) = k8s.clusterrolebinding(me);

local configmap(me) = k8s.configmap(me) {
  data: {
    'cwagentconfig.json': std.manifestJson(
      {
        agent: {
          region: me.config.cluster.metadata.region,
        },
        logs: {
          metrics_collected: {
            kubernetes: {
              cluster_name: me.config.cluster.metadata.name,
              metrics_collection_interval: 60,
            },
          },
          force_flush_interval: 15,
        },
      }
    ),
  },
};

local daemonset(me, serviceAccount=true) =
  k8s.daemonset(me,
                containers={
                  env: [
                    k8s.envVar('CLUSTER_NAME', me.config.cluster.metadata.name),
                    k8s.envField('HOST_IP', 'status.hostIP'),
                    k8s.envField('HOST_NAME', 'spec.nodeName'),
                    k8s.envField('K8S_NAMESPACE', 'metadata.namespace'),
                  ],
                  image: 'amazon/cloudwatch-agent:latest',
                  resources: {
                    limits: {
                      cpu: '200m',
                      memory: '200Mi',
                    },
                    requests: {
                      cpu: '200m',
                      memory: '200Mi',
                    },
                  },
                  volumeMounts: [
                    {
                      mountPath: '/etc/cwagentconfig',
                      name: me.pkg,
                    },
                    {
                      mountPath: '/rootfs',
                      name: 'rootfs',
                      readOnly: true,
                    },
                    {
                      mountPath: '/var/run/docker.sock',
                      name: 'dockersock',
                      readOnly: true,
                    },
                    {
                      mountPath: '/var/lib/docker',
                      name: 'varlibdocker',
                      readOnly: true,
                    },
                    {
                      mountPath: '/sys',
                      name: 'sys',
                      readOnly: true,
                    },
                    {
                      mountPath: '/dev/disk',
                      name: 'devdisk',
                      readOnly: true,
                    },
                  ],
                },

                volumes=[
                  {
                    configMap: {
                      name: me.pkg,
                    },
                    name: me.pkg,
                  },
                  {
                    hostPath: {
                      path: '/',
                    },
                    name: 'rootfs',
                  },
                  {
                    hostPath: {
                      path: '/var/run/docker.sock',
                    },
                    name: 'dockersock',
                  },
                  {
                    hostPath: {
                      path: '/var/lib/docker',
                    },
                    name: 'varlibdocker',
                  },
                  {
                    hostPath: {
                      path: '/sys',
                    },
                    name: 'sys',
                  },
                  {
                    hostPath: {
                      path: '/dev/disk/',
                    },
                    name: 'devdisk',
                  },
                ], serviceAccount=true) {
    spec+: {
      template+: {
        spec+: {
          terminationGracePeriodSeconds: 60,
        },
      },
    },
  };

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    daemonset(me),
    clusterrole(me),
    clusterrolebinding(me),
    configmap(me),
  ]
)

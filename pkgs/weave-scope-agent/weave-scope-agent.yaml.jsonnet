local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local daemonset(me) = k8s.daemonset(
  me,
  containers={
    args: [
      '--mode=probe',
      '--probe-only',
      '--probe.kubernetes.role=host',
      '--probe.publish.interval=4500ms',
      '--probe.spy.interval=2s',
      '--probe.docker.bridge=docker0',
      '--probe.docker=true',
      'weave-scope-app.%s.svc.cluster.local:80' % me.namespace,
    ],
    command: [
      '/home/weave/scope',
    ],
    env: [],
    image: 'docker.io/weaveworks/scope:1.13.0',
    resources: {
      requests: {
        cpu: '100m',
        memory: '100Mi',
      },
    },
    securityContext: {
      privileged: true,
    },
    volumeMounts: [
      {
        mountPath: '/var/run/scope/plugins',
        name: 'scope-plugins',
      },
      {
        mountPath: '/sys/kernel/debug',
        name: 'sys-kernel-debug',
      },
      {
        mountPath: '/var/run/docker.sock',
        name: 'docker-socket',
      },
    ],
  },
  volumes=[
    {
      hostPath: {
        path: '/var/run/scope/plugins',
      },
      name: 'scope-plugins',
    },
    {
      hostPath: {
        path: '/sys/kernel/debug',
      },
      name: 'sys-kernel-debug',
    },
    {
      hostPath: {
        path: '/var/run/docker.sock',
      },
      name: 'docker-socket',
    },
  ]
) {
  spec+: {
    template+: {
      spec+: {
        dnsPolicy: 'ClusterFirstWithHostNet',
        hostNetwork: true,
        hostPID: true,
        tolerations: [
          {
            effect: 'NoSchedule',
            operator: 'Exists',
          },
          {
            effect: 'NoExecute',
            operator: 'Exists',
          },
        ],
      },
    },
    updateStrategy: {
      type: 'RollingUpdate',
    },
  },
};

function(config, prev, namespace, pkg) daemonset(common.package(config, prev, namespace, pkg))

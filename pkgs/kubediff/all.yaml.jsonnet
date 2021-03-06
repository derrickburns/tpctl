local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '*',
      ],
      resources: [
        '*',
      ],
      verbs: [
        'get',
      ],
    },
  ],
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, 80)],
  },
};

local deployment(me) = k8s.deployment(
  me,
  serviceAccount=true,
  containers={
    'git-sync': {
      args: [
        '-repo=%s' % me.config.general.github.https,
        '-wait=60',
        '-dest=/data/repo',
      ],
      env: [
        {
          name: 'GIT_SYNC_USERNAME',
          valueFrom: {
            secretKeyRef: {
              key: 'username',
              name: me.pkg,
            },
          },
        },
        {
          name: 'GIT_SYNC_PASSWORD',
          valueFrom: {
            secretKeyRef: {
              key: 'password',
              name: me.pkg,
            },
          },
        },
      ],
      image: 'tomwilkie/git-sync:f6165715ce9d',
      volumeMounts: [
        {
          mountPath: '/data',
          name: 'repo',
        },
      ],
    },
    kubediff: {
      args: [
        '-period=60s',
        '-listen-addr=:80',
        '/kubediff',
        '/data/repo/manifests',
      ],
      image: 'weaveworks/kubediff',
      ports: [
        {
          containerPort: 80,
        },
      ],
      volumeMounts: [
        {
          mountPath: '/data',
          name: 'repo',
        },
      ],
    },
  },
  volumes=[
    {
      emptyDir: {},
      name: 'repo',
    },
  ]
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    clusterrole(me),
    k8s.clusterrolebinding(me),
    k8s.serviceaccount(me),
  ]
)

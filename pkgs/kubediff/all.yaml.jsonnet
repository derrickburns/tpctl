local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, 80)],
  },
};

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    'git-sync': {
      args: [
        '-repo=%s' % me.config.general.github.https,
        '-wait=60',
        '-dest=manifests',
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
        '/data/repo/<location in your repo of yaml files>',
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
  spec+: {
    template+: {
      spec+: {
        volumes: [
          {
            emptyDir: {},
            name: 'repo',
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

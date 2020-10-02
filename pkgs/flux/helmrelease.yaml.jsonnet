local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secretName = 'fluxrecv-config';

local helmrelease(me) = k8s.helmrelease(
  me,
  {
    version: '1.3.0',
    repository: 'https://charts.fluxcd.io',
  },
  secretNames=if lib.isEnabledAt(me.config.namespaces[me.namespace], 'fluxrecv') && lib.isTrue(me.config.namespaces[me.namespace], 'fluxrecv.sidecar') then [secretName] else []
) {

  local ns = me.config.namespaces[me.namespace],

  spec+: {
    values: {
      image: {
        tag: lib.getElse(me, 'version', '1.20.1'),
      },

      helm: {
        versions: 'v3',
      },

      logFormat: 'fmt',

      sops: {
        enabled: true,
      },

      git: {
        label: me.config.cluster.metadata.name,
        email: me.config.general.email,
        url: '%s.git' % me.config.general.github.git,
        path: 'generated',
      },

      prometheus: {
        serviceMonitor: {
          create: global.isEnabled(me.config, 'kube-prometheus-stack'),
        },
      },

      serviceAccount: {
        create: false,
        name: 'flux',
      },

      sync: {
        timeout: '10m',
      },

      syncGarbageCollection: {
        enabled: true,
        dry: false,
      },

      additionalArgs:
        ['--registry-exclude-image=*velero*']  // XXX hardcoded
        + ['--registry-exclude-image=*kafka-prometheus-jmx-exporte*']  // XXX hardcoded
        + if lib.isTrue(ns, 'fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

      extraContainers:
        if lib.isEnabledAt(ns, 'fluxrecv') && lib.isTrue(ns, 'fluxrecv.sidecar')
        then [{
          name: 'recv',
          image: 'fluxcd/flux-recv:%s' % lib.getElse(ns, 'fluxrecv.version', '0.3.0'),
          imagePullPolicy: 'IfNotPresent',
          args: ['--config=/etc/fluxrecv/fluxrecv.yaml'],
          ports: [{
            containerPort: 8080,
          }],
          volumeMounts: [{
            name: 'fluxrecv-config',
            mountPath: '/etc/fluxrecv',
          }],
        }]
        else [],

      extraVolumes:
        if lib.isEnabledAt(ns, 'fluxrecv') && lib.isTrue(ns, 'fluxrecv.sidecar')
        then [{
          name: 'fluxrecv-config',
          secret: {
            secretName: secretName,
            defaultMode: std.parseOctal('0400'),
          },
        }]
        else [],

      resources: {
        requests: {
          cpu: '75m',
          memory: '128Mi',
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

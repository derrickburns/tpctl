local global = import '../../lib/global.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, {
  version: '1.3.0',
  repository: 'https://charts.fluxcd.io',
}) {

  local ns = me.config.namespaces[me.namespace],
  _secretNames:: if lib.isEnabledAt(ns, 'fluxrecv') && lib.isTrue(ns, 'fluxrecv.sidecar') then ['fluxrecv-config'] else [],

  spec+: {
    values: {
      image: {
        tag: lib.getElse(me, 'version', '1.19.0'),
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
        enabled: global.isEnabled(me.config, 'prometheus'),
        serviceMonitor: {
          create: global.isEnabled(me.config, 'prometheus-operator'),
        },
      },

      sync: {
        timeout: '10m',
      },

      syncGarbageCollection: {
        enabled: true,
        dry: false,
      },

      additionalArgs:
       [ '--registry-exclude-image=*velero*' ] // XXX hardcoded
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
        if std.length($._secretNames) > 0
        then [{
          name: 'fluxrecv-config',
          secret: {
            secretName: $._secretNames[0],
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

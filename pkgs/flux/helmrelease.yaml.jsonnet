local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '1.3.0', repository: 'https://charts.fluxcd.io' }) {
  spec+: {
    values: {
      local ns = config.namespaces[me.namespace],
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
        label: config.cluster.metadata.name,
        email: config.general.email,
        url: '%s.git' % config.general.github.git,
      },

      prometheus: {
        enabled: global.isEnabled(config, 'prometheus'),
        serviceMonitor: {
          create: global.isEnabled(config, 'prometheus-operator'),
        },
      },

      sync: {
        timeout: '10m',
      },

      syncGarbageCollection: {
        enabled: true,
        dry: false,
      },

      additionalArgs: if lib.isTrue(ns, 'fluxcloud.enabled') then ['--connect=ws://fluxcloud'] else [],

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
            secretName: 'fluxrecv-config',
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

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))

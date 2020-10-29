local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local pomerium = import '../../lib/pomerium.jsonnet';
local tracing = import '../../lib/tracing.jsonnet';

local getPoliciesForPackage(me) = [
  {
    local config = me.config,
    local port = lib.getElse(sso, 'port', 8080),
    local suffix = if port == 80 then '' else ':%s' % port,
    local serviceRoute = 'http://' + lib.getElse(sso, 'serviceName', me.pkg) + '.' + me.namespace + '.svc.cluster.local',
    local internalHost = lib.getElse(sso, 'internalHost', serviceRoute),
    from: 'https://' + pomerium.dnsNameForSso(config, me, sso),
    to: 'http://' + internalHost + suffix,
    allowed_groups: lib.getElse(sso, 'allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
    allowed_users: lib.getElse(sso, 'allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
    allow_websockets: lib.getElse(sso, 'allow_websockets', lib.getElse(config, 'general.sso.allow_websockets', true)),
  }
  for sso in pomerium.ssoList(me)
];


local getPolicy(me) = std.flattenArrays([getPoliciesForPackage(pkg) for pkg in global.packagesWithKey(me.config, 'sso')]);

local secretName = 'pomerium';
local configmapName = 'pomerium';

local helmrelease(me) = k8s.helmrelease(
  me,
  { version: '7.0.0', repository: 'https://helm.pomerium.io' },
  secretNames=[secretName],
  configmapNames=[configmapName]
) {

  local domain = pomerium.rootDomain(me.config),
  spec+: {
    values+: {
      authenticate: {
        idp: {
          serviceAccount: true,
        },
      },
      extraEnv: {
        LOG_LEVEL: lib.getElse(me, 'logLevel', lib.getElse(me.config, 'general.logLevel', 'info')),
        POLICY: std.base64(std.manifestJson(getPolicy(me))),
        METRICS_ADDRESS: ':9090',
      },
      service: {
        type: 'ClusterIP',
      },
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
      },
      metrics: {
        enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
      },
      config: {
        rootDomain: domain,
        existingSecret: secretName,
      },
      forwardAuth: {
        enabled: false,
      },
      ingress: {
        enabled: false,
      },
      tracing: if global.isEnabled(me.config, 'jaeger') then {
        provider: 'jaeger',
        jaeger: {
          collector_endpoint: tracing.collector(me),
          agent_endpoint: tracing.agent(me),
        },
      } else {},
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)

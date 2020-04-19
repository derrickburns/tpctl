local certmanager = import '../../lib/certmanager.jsonnet';
local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local pomerium = import '../../lib/pom.jsonnet';

local upstream(me, name) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata(name, me.namespace) {
  spec: {
    discoveryMetadata: {},
    kube: {
      selector: {
        'app.kubernetes.io/instance': 'pomerium',
        'app.kubernetes.io/name': name,
      },
      serviceName: name,
      serviceNamespace: me.namespace,
      servicePort: 443,
    },
    sslConfig: {
      secretRef: {
        name: '%s-tls' % name,
        namespace: me.namespace,
      },
    },
  },
};

local virtualService(me, name) = k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata(name, me.namespace) {
  local domain = pomerium.rootDomain(me.config),
  metadata+: {
    labels: {
      protocol: 'https',
      type: 'pomerium',
    },
  },
  spec: {
    displayName: name,
    sslConfig: {
      secretRef: {
        name: '%s-tls' % me.pkg,
        namespace: me.namespace,
      },
      sniDomains: [
        '%s.%s' % [name, domain],
      ],
    },
    virtualHost: {
      domains: [
        '%s.%s' % [name, domain],
      ],
      routes: [
        {
          matchers: [
            {
              prefix: '/',
            },
          ],
          routeAction: {
            single: {
              upstream: {
                name: 'pomerium-%s' % name,
                namespace: me.namespace,
              },
            },
          },
        },
      ],
    },
  },
};

local dnsNames(me) =
  ['authenticate.%s' % pomerium.rootDomain(me.config), 'authorize.%s' % pomerium.rootDomain(me.config)] + pomerium.dnsNames(me.config);

local certificate(me) = certmanager.certificate(me, dnsNames(me));

local getPoliciesForPackage(me) = [
  {
    local config = me.config,
    local port = lib.getElse(sso, 'port', 8080),
    local suffix = if port == 80 then '' else ':%s' % port,
    from: 'https://' + pomerium.dnsNameForSso(config, me, sso),
    to: 'http://' + lib.getElse(sso, 'serviceName', me.pkg) + '.' + me.namespace + '.svc.cluster.local' + suffix,
    allowed_groups: lib.getElse(sso, 'allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
    allowed_users: lib.getElse(sso, 'allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
    allow_websockets: lib.getElse(sso, 'allow_websockets', lib.getElse(config, 'general.sso.allow_websockets', true)),
  }
  for sso in pomerium.ssoList(me)
];

local getPolicy(me) = std.flattenArrays([getPoliciesForPackage(pkg) for pkg in global.packagesWithKey(me.config, 'sso')]);

local helmrelease(me) = k8s.helmrelease(me, { version: '5.0.3', repository: 'https://helm.pomerium.io' }) {
  _secretNames:: ['pomerium'],
  _configmapNames:: ['pomerium'],
  local domain = pomerium.rootDomain(me.config),
  spec+: {
    values+: {
      authenticate: {
        idp: {
          serviceAccount: true,
        },
      },
      extraEnv: {
        log_level: lib.getElse(me, 'logLevel', lib.getElse(me.config, 'general.logLevel', 'info')),
      },
      service: {
        type: 'ClusterIP',
      },
      config: {
        rootDomain: domain,
        existingSecret: $._secretNames[0],
        policy: getPolicy(me),
      },
      forwardAuth: {
        enabled: false,
      },
      ingress: {
        enabled: false,
      },
    },
  },
};

local httpsVirtualService(me) = k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata('proxy-https', me.namespace) {
  local domains = pomerium.dnsNames(me.config),
  metadata+: {
    labels: {
      protocol: 'https',
      type: 'pomerium',
    },
  },
  spec: {
    displayName: 'proxy-https',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: me.namespace,
      },
      sniDomains: domains,
    },
    virtualHost: {
      domains: domains,
      routes: [
        {
          matchers: [
            {
              prefix: '/',
            },
          ],
          routeAction: {
            single: {
              upstream: {
                name: 'pomerium-proxy',
                namespace: me.namespace,
              },
            },
          },
          options: {
            headerManipulation: {
              requestHeadersToRemove: ['Origin'],
            },
            upgrades: [
              {
                websocket: {
                  enabled: true,
                },
              },
            ],
          },
        },
      ],
    },
  },
};

local httpVirtualService(me) = k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata('proxy-http', me.namespace) {
  metadata+: {
    labels: {
      protocol: 'http',
      type: 'pomerium',
    },
  },
  spec: {
    displayName: 'proxy-http',
    virtualHost: {
      domains: pomerium.dnsNames(me.config),
      routes: [
        {
          matchers: [
            {
              prefix: '/',
            },
          ],
          redirectAction: {
            httpsRedirect: true,
          },
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) {
  local me = common.package(config, prev, namespace, pkg),
  helm: helmrelease(me),
  gloo: [
    httpVirtualService(me),
    httpsVirtualService(me),
    virtualService(me, 'authorize'),
    virtualService(me, 'authenticate'),
    upstream(me, 'pomerium-proxy'),
    upstream(me, 'pomerium-authenticate'),
    upstream(me, 'pomerium-authorize'),
  ],
  certmanager: certificate(me),

}

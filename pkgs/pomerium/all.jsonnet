local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import '../../pom.jsonnet';

local upstream(name, namespace) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata(name, namespace) {
  spec: {
    discoveryMetadata: {},
    kube: {
      selector: {
        'app.kubernetes.io/instance': 'pomerium',
        'app.kubernetes.io/name': name,
      },
      serviceName: name,
      serviceNamespace: namespace,
      servicePort: 443,
    },
    sslConfig: {
      secretRef: {
        name: '%s-tls' % name,
        namespace: namespace,
      },
    },
  },
};

local virtualService(config, name, namespace) = k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata(name, namespace) {
  local domain = mylib.rootDomain(config),
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
        name: 'pomerium-tls',
        namespace: namespace,
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
                namespace: namespace,
              },
            },
          },
        },
      ],
    },
  },
};

local certificate(config, namespace) = k8s.k('cert-manager.io/v1alpha2', 'Certificate') + k8s.metadata('pomerium-certificate', namespace) {
  spec: {
    secretName: 'pomerium-tls',
    issuerRef: {
      name: lib.getElse(global.package(config, 'certmanager'), 'issuer', 'letsencrypt-production'),
      kind: 'ClusterIssuer',
    },
    commonName: self.dnsNames[0],
    dnsNames: ['authenticate.%s' % mylib.rootDomain(config), 'authorize.%s' % mylib.rootDomain(config)] + mylib.dnsNames(config),
  },
};

local getPoliciesForPackage(config, me) = [
  {
    local port = lib.getElse(sso, 'port', 8080),
    local suffix = if port == 80 then '' else ':%s' % port,
    from: 'https://' + mylib.dnsNameForSso(config, me, sso),
    to: 'http://' + lib.getElse(sso, 'serviceName', me.pkg) + '.' + me.namespace + '.svc.cluster.local' + suffix,
    allowed_groups: lib.getElse(sso, 'allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
    allowed_users: lib.getElse(sso, 'allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
    allow_websockets: lib.getElse(sso, 'allow_websockets', lib.getElse(config, 'general.sso.allow_websockets', true)),
  }
  for sso in mylib.ssoList(me)
];

local getPolicy(config) = std.flattenArrays([getPoliciesForPackage(config, pkg) for pkg in global.packagesWithKey(config, 'sso')]);

local helmrelease(config, me) = k8s.helmrelease(me, { version: '5.0.3', repository: 'https://helm.pomerium.io' }) {
  _secretNames:: ['pomerium'],
  _configmapNames:: ['pomerium'],
  local domain = mylib.rootDomain(config),
  spec+: {
    values+: {
      authenticate: {
        idp: {
          serviceAccount: true,
        },
      },
      extraEnv: {
        log_level: lib.getElse(me, 'logLevel', lib.getElse(config, 'general.logLevel', 'info')),
      },
      service: {
        type: 'ClusterIP',
      },
      config: {
        rootDomain: domain,
        existingSecret: $._secretNames[0],
        policy: getPolicy(config),
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

local httpsVirtualService(config, namespace) = k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata('proxy-https', namespace) {
  local domains = mylib.dnsNames(config),
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
        namespace: namespace,
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
                namespace: namespace,
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

local httpVirtualService(config, namespace) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'http',
      type: 'pomerium',
    },
    name: 'proxy-http',
    namespace: namespace,
  },
  spec: {
    displayName: 'proxy-http',
    virtualHost: {
      domains: mylib.dnsNames(config),
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

function(config, prev, namespace, pkg) [
  helmrelease(config, common.package(config, prev, namespace, pkg)),
  httpVirtualService(config, namespace),
  httpsVirtualService(config, namespace),
  virtualService(config, 'authorize', namespace),
  virtualService(config, 'authenticate', namespace),
  upstream('pomerium-proxy', namespace),
  upstream('pomerium-authenticate', namespace),
  upstream('pomerium-authorize', namespace),
  certificate(config, namespace),
]

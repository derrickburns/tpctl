local lib = import 'lib.jsonnet';

local providesHelmRepo(me) = std.objectHas(me, 'version') && std.objectHas(me, 'name') && std.objectHas(me, 'repository');

local providesGitRepo(me) = std.objectHas(me, 'git') && std.objectHas(me, 'path') && std.objectHas(me, 'ref');

local helm(me) = {
  repository: me.repository,
  name: me.name,
  version: me.version,
};

local git(me) = {
  git: me.git,
  path: me.path,
  ref: me.ref,
};

local chart(me, values) = (
  local defaults = { path: '.', ref: 'master', repository: 'https://kubernetes-charts.storage.googleapis.com' };
  local custom = { name: me.pkg } + lib.getElse(me, 'chart', {});
  local withDefaults = { name: me.pkg } + defaults + values + custom;

  if providesHelmRepo(custom) then helm(custom)
  else if providesGitRepo(custom) then git(custom)
  else if providesHelmRepo(withDefaults) then helm(withDefaults)
  else if providesGitRepo(withDefaults) then git(withDefaults)
  else {}
);

{
  k(apiVersion, kind):: {
    apiVersion: apiVersion,
    kind: kind,
  },

  metadata(name, namespace=''):: {
    metadata: {
                name: name,
              } +
              if namespace != '' then { namespace: namespace } else {},
  },

  serviceaccount(me):: $.k('v1', 'ServiceAccount') + $.metadata(me.pkg, me.namespace),

  configmap(me):: $.k('v1', 'ConfigMap') + $.metadata(me.pkg, me.namespace),

  clusterrolebinding(me):: $.k('rbac.authorization.k8s.io/v1', 'ClusterRoleBinding') + $.metadata(me.pkg) {
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: me.pkg,
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: me.pkg,
        namespace: me.namespace,
      },
    ],
  },

  deployment(me):: $.k('apps/v1', 'Deployment') + $.metadata(me.pkg, me.namespace) {
    metadata+: {
      labels: {
        app: me.pkg,
      },
    },
    spec+: {
      strategy: {
        type: 'Recreate',
      },
      replicas: 1,
      selector+: {
        matchLabels: {
          app: me.pkg,
        },
      },
      template+: {
        metadata+: {
          labels: {
            app: me.pkg,
          },
        },
        spec+: {
          restartPolicy: 'Always',
        },
      },
    },
  },

  helmrelease(me, chartValues):: 
    $.k('helm.fluxcd.io/v1', 'HelmRelease') + $.metadata(me.pkg, me.namespace) {
      spec+: {
        releaseName: me.pkg,
        chart: chart(me, chartValues),
      },
    },

  service(me, type='ClusterIP'):: $.k('v1', 'Service') + $.metadata(me.pkg, me.namespace) {
    metadata+: {
      labels: {
        app: me.pkg
      },
    },
    spec+: {
      type: type,
      selector: {
        app: me.pkg,
      },
    },
  },

  port(port=8080, targetPort=8080, name='http', protocol='TCP'):: {
    name: name,
    port: port,
    protocol: protocol,
    targetPort: targetPort,
  },

  pod(me):: $.k('v1', 'Pod') + $.metadata(me.pkg, me.namespace),
}

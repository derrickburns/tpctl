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

local fluxAnnotations(me) = {
  'fluxcd.io/automated': 'true',
  ['fluxcd.io/tag.%s' % me.pkg]: 'glob:master-*',
};

local reloaderAnnotations(this) = (
  (if std.objectHasAll(this, '_secretNames') && std.length(this._secretNames) > 0
   then { 'secret.reloader.stakater.com/reload': std.join(',', std.set(this._secretNames)) }
   else {}) +
  (if std.objectHasAll(this, '_configmapNames') && std.length(this._configmapNames) > 0
   then { 'configmap.reloader.stakater.com/reload': std.join(',', std.set(this._configmapNames)) }
   else {})
);

local secretNameFromVolume(v) = lib.getElse(v, 'secret.secretName', null);

local configmapNameFromVolume(v) = lib.getElse(v, 'configMap.name', null);

local secretNameFromEnvVar(e) = lib.getElse(e, 'valueFrom.secretKeyRef.name', null);

local secretNameFromEnv(e) = lib.getElse(e, 'secretRef.name', null);

local configmapNameFromEnvVar(e) = lib.getElse(e, 'valueFrom.configMapKeyRef.name', null);

local configmapNameFromEnv(e) = lib.getElse(e, 'configMapRef.name', null);

local secretNamesFromContainer(c) =
  [secretNameFromEnvVar(e) for e in lib.getElse(c, 'env', [])]
  + [secretNameFromEnv(e) for e in lib.getElse(c, 'envFrom', [])];

local configmapNamesFromContainer(c) =
  [configmapNameFromEnvVar(e) for e in lib.getElse(c, 'env', [])]
  + [configmapNameFromEnv(e) for e in lib.getElse(c, 'envFrom', [])];


local secretNamesFromPod(pod) = lib.pruneList(
  [secretNameFromVolume(v) for v in lib.getElse(pod, 'volumes', [])]
  + std.flattenArrays([secretNamesFromContainer(c) for c in lib.getElse(pod, 'containers', [])])
);

local configmapNamesFromPod(pod) = lib.pruneList(
  [configmapNameFromVolume(v) for v in lib.getElse(pod, 'volumes', [])]
  + std.flattenArrays([configmapNamesFromContainer(c) for c in lib.getElse(pod, 'containers', [])])
);

{

  key(o): (
    assert std.objectHas(o, 'apiVersion') : std.manifestJson(o);
    assert std.objectHas(o, 'kind') : std.manifestJson(o);
    assert std.objectHas(o, 'metadata') : std.manifestJson(o);
    assert std.objectHas(o.metadata, 'name') : std.manifestJson(o);
    "%s %s %s %s" % [o.apiVersion, o.kind, o.metadata.name, lib.getElse( o, 'metadata.namespace', '---')]
  ),

  isResource(o):: std.isObject(o) && std.objectHas(o, 'apiVersion') && std.objectHas(o, 'kind'),

  flatten(o)::
    if $.isResource(o) then [o]
    else if std.isObject(o) then std.flattenArrays(std.map($.flatten, lib.values(o)))
    else if std.isArray(o) then std.flattenArrays(std.map($.flatten, o))
    else [],

  find(o, requestedKey):: (
    local matches = std.filter(function(x) $.key(x) == requestedKey, $.flatten(o));
    if std.length(matches) == 1 then matches[0] else {}
  ),

  findMatch(prev, x):: if $.isResource(x) then $.find(prev, $.key(x)) else {},

  k(apiVersion, kind):: {
    apiVersion: apiVersion,
    kind: kind,
  },

  metadata(name, namespace=''):: {
    metadata: {
                name: name,
                labels: {
                  app: name,
                },
              } +
              if namespace != '' then { namespace: namespace } else {},
  },

  serviceaccount(me):: $.k('v1', 'ServiceAccount') + $.metadata(me.pkg, me.namespace),

  secret(me, name=''):: $.k('v1', 'Secret') + $.metadata(if name == '' then me.pkg else name, me.namespace) {
    type: 'Opaque',
  },

  configmap(me, name=''):: $.k('v1', 'ConfigMap') + $.metadata(if name == '' then me.pkg else name, me.namespace),

  clusterrole(me):: $.k('rbac.authorization.k8s.io/v1', 'ClusterRole') + $.metadata(me.pkg),

  role(me):: $.k('rbac.authorization.k8s.io/v1', 'Role') + $.metadata(me.pkg),

  rolebinding(me):: $.k('rbac.authorization.k8s.io/v1', 'RoleBinding') + $.metadata(me.pkg) {
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'Role',
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

  statefulset(me):: $.k('apps/v1', 'StatefulSet') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    spec+: {
      serviceName: me.pkg,
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
      },
    },
  },

  daemonset(me):: $.k('apps/v1', 'DaemonSet') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    _secretNames:: secretNamesFromPod(this.spec.template.spec),
    _configmapNames:: configmapNamesFromPod(this.spec.template.spec),
    metadata+:
      (if reloaderAnnotations(this) != {}
       then { annotations+: reloaderAnnotations(this) }
       else {}),
    spec+: {
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

  deployment(me, automated=false):: $.k('apps/v1', 'Deployment') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    _secretNames:: secretNamesFromPod(this.spec.template.spec),
    _configmapNames:: configmapNamesFromPod(this.spec.template.spec),
    metadata+: {
      annotations+: {} + reloaderAnnotations(this) +
                    (if automated then fluxAnnotations(me) else {}),
    },
    spec+: {
      revisionHistoryLimit: 10,
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
          securityContext+: $.securityContext,
          restartPolicy: 'Always',
          containers:
            if std.objectHasAll(this, 'containerPatch') 
	    then this.containerPatch(me.prev, this, $.containers(me, this))
            else $.containers(me, this)
        },
      },
    },
  },

  helmrelease(me, chartValues):: $.k('helm.fluxcd.io/v1', 'HelmRelease') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    spec+: {
      values+: {
        annotations+: reloaderAnnotations(this),
      },
      releaseName: lib.getElse(me, 'releaseName', me.pkg),
      chart: chart(me, chartValues),
    },
  },

  service(me, type='ClusterIP'):: $.k('v1', 'Service') + $.metadata(me.pkg, me.namespace) {
    spec+: {
      type: type,
      selector: {
        app: me.pkg,
      },
    },
  },

  pvc(me, storage=''):: $.k('v1', 'PersistentVolumeClaim') + $.metadata(me.pkg, me.namespace) {
    spec+: {
      accessModes: [
        'ReadWriteOnce',
      ],
    } + if storage != ''
    then {
      resources: {
        requests: {
          storage: storage,
        },
      },
    }
    else {},
  },

  port(port=8080, targetPort=8080, name='http', protocol='TCP'):: {
    name: name,
    port: port,
    protocol: protocol,
    targetPort: targetPort,
  },

  pod(me):: $.k('v1', 'Pod') + $.metadata(me.pkg, me.namespace) {
    spec+: {
      securityContext+: $.securityContext,
    },
  },

  envField(name, path):: {
    name: name,
    valueFrom: {
      fieldRef: {
        fieldPath: path,
      },
    },
  },

  envVar(env, value):: {
    name: env,
    value: value,
  },

  envConfigmap(env, cm, key, optional=false):: {
    name: env,
    valueFrom: {
      configMapKeyRef: {
        name: cm,
        key: key,
        optional: optional,
      },
    },
  },
  envSecret(env, secret, key, optional=false):: {
    name: env,
    valueFrom: {
      secretKeyRef: {
        name: secret,
        key: key,
        optional: optional,
      },
    },
  },

  securityContext:: {
    // sysctls: [ {
    //name: "net.netfilter.nf_conntrack_tcp_timeout_close_waits",
    //value: "240",
    //} ],
  },

  // add image pull policy based on image tag
  withImagePullPolicy(container):: 
    if std.endsWith(lib.getElse(container, 'image', ''), ':latest')
    then container { imagePullPolicy: 'Always' }
    else container { imagePullPolicy: 'IfNotPresent' },


  // Add names to containers if provided as map
  // If a single container is provided, provide it the default name
  containersWithName(me, this)::
    if ! std.objectHasAll(this, '_containers') then []
    else if std.isArray(this._containers) then this._containers
    else if std.objectHas(this._containers, 'image') && std.isString(this._containers.image)
    then [ this._containers { name: lib.getElse(this._containers, 'name', me.pkg) } ]
    else lib.asArrayWithField(lib.getElse(this, '_containers', {}), 'name'),

  // add names and image pull policy to containers
  containers(me, this):: 
    std.map( function(c) $.withImagePullPolicy(c), $.containersWithName(me, this)),
}

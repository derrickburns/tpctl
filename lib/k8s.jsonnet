local lib = import 'lib.jsonnet';
local linkerd = import 'linkerd.jsonnet';

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
  local custom = lib.getElse(me, 'chart', {});
  local withDefaults = { name: me.typeName } + defaults + values + custom;

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

local reloaderAnnotations(secretNames, configmapNames) = (
  (if std.length(secretNames) > 0
   then { 'secret.reloader.stakater.com/reload': std.join(',', std.set(secretNames)) }
   else {}) +
  (if std.length(configmapNames) > 0
   then { 'configmap.reloader.stakater.com/reload': std.join(',', std.set(configmapNames)) }
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

local secretNamesFromContainers(containers, volumes) = lib.pruneList(
  [secretNameFromVolume(v) for v in volumes]
  + std.flattenArrays([secretNamesFromContainer(c) for c in containers])
);

local configmapNamesFromContainers(containers, volumes) = lib.pruneList(
  [configmapNameFromVolume(v) for v in volumes]
  + std.flattenArrays([configmapNamesFromContainer(c) for c in containers])
);

{

  key(o): (
    assert std.objectHas(o, 'apiVersion') : std.manifestJson(o);
    assert std.objectHas(o, 'kind') : std.manifestJson(o);
    assert std.objectHas(o, 'metadata') : std.manifestJson(o);
    assert std.objectHas(o.metadata, 'name') : std.manifestJson(o);
    '%s %s %s %s' % [o.apiVersion, o.kind, o.metadata.name, lib.getElse(o, 'metadata.namespace', '---')]
  ),

  isResource(o):: std.isObject(o) && std.objectHas(o, 'apiVersion') && std.objectHas(o, 'kind'),

  isList(o):: $.isResource(o) && lib.isEq(o, 'kind', 'List'),

  flatten(o)::
    if $.isList(o) then std.flattenArrays(std.map($.flatten, o.items))
    else if $.isResource(o) then [o]
    else if std.isObject(o) then std.flattenArrays(std.map($.flatten, lib.values(o)))
    else if std.isArray(o) then std.flattenArrays(std.map($.flatten, o))
    else [],

  asMap(o)::
    if $.isResource(o) then { [$.key(o)]+: o }
    else { [$.key(x)]: x for x in o },

  patch(resourceMap, p)::
    if std.objectHas(resourceMap, $.key(p))
    then resourceMap { [$.key(p)]: std.mergePatch(resourceMap[$.key(p)], p) }
    else resourceMap,

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

  secret(me, name=me.pkg):: $.k('v1', 'Secret') + $.metadata(name, me.namespace) {
    type: 'Opaque',
  },

  configmap(me, name=me.pkg):: $.k('v1', 'ConfigMap') + $.metadata(name, me.namespace),

  clusterrole(me):: $.k('rbac.authorization.k8s.io/v1', 'ClusterRole') + $.metadata(me.pkg),

  role(me):: $.k('rbac.authorization.k8s.io/v1', 'Role') + $.metadata(me.pkg),

  rolebinding(me, name=me.pkg):: $.k('rbac.authorization.k8s.io/v1', 'RoleBinding') + $.metadata(name, me.namespace) {
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
  clusterrolebinding(me, namespace='', name=me.pkg, roleName=me.pkg):: $.k('rbac.authorization.k8s.io/v1', 'ClusterRoleBinding') + $.metadata(name, namespace) {
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: roleName,
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: me.pkg,
        namespace: me.namespace,
      },
    ],
  },

  statefulset(me, containers=[], volumes=[], serviceAccount = false):: $.k('apps/v1', 'StatefulSet') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    local containerList = $.toContainerList(me, containers),
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
        spec+:
          (if std.length(volumes) > 0 then { volumes: volumes } else {}) +
          (if serviceAccount then { serviceAccountName: me.pkg } else {}) + 
          {
            restartPolicy: 'Always',
            containers:
              if std.objectHasAll(this, 'containerPatch')
              then this.containerPatch(me.prev, this, containerList)
              else containerList,
          },
      },
    },
  },

  daemonset(me, containers=[], volumes=[], serviceAccount = false):: $.k('apps/v1', 'DaemonSet') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    local containerList = $.toContainerList(me, containers),
    local secretNames = secretNamesFromContainers(containerList, volumes),
    local configmapNames = configmapNamesFromContainers(containerList, volumes),
    metadata+:
      (if reloaderAnnotations(secretNames, configmapNames) != {}
       then { annotations+: reloaderAnnotations(secretNames, configmapNames) }
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
        spec+: 
          (if std.length(volumes) > 0 then { volumes: volumes } else {}) +
          (if serviceAccount then { serviceAccountName: me.pkg } else {}) + 
          {
          restartPolicy: 'Always',
          containers:
              if std.objectHasAll(this, 'containerPatch')
              then this.containerPatch(me.prev, this, containerList)
              else containerList,
        },
      },
    },
  },

  deployment(me, automated=false, containers=[], volumes=[], serviceAccount = false):: $.k('apps/v1', 'Deployment') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    local containerList = $.toContainerList(me, containers),
    local secretNames = secretNamesFromContainers(containerList, volumes),
    local configmapNames = configmapNamesFromContainers(containerList, volumes),
    local annotations = reloaderAnnotations(secretNames, configmapNames) + (if automated then fluxAnnotations(me) else {}),
    metadata+: if annotations != {} then { annotations+: annotations } else {},
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
      template+: linkerd.metadata(me) {
        metadata+: {
          labels+: {
            app: me.pkg,
          },
        },
        spec+: 
          (if std.length(volumes) > 0 then { volumes: volumes } else {}) +
          (if serviceAccount then { serviceAccountName: me.pkg } else {}) + 
          {
            securityContext+: $.securityContext,
            restartPolicy: 'Always',
            containers:
              if std.objectHasAll(this, 'containerPatch')
              then this.containerPatch(me.prev, this, containerList)
              else containerList,
          },
      },
    },
  },

  helmrelease(me, chartValues, secretNames=[], configmapNames=[]):: $.k('helm.fluxcd.io/v1', 'HelmRelease') + $.metadata(me.pkg, me.namespace) {
    local this = self,
    local vals = chart(me, chartValues),
    spec+: {
      values+: {
        annotations+: reloaderAnnotations(secretNames, configmapNames),
      },
      releaseName: lib.getElse(me, 'releaseName', me.pkg),
      chart: vals,
    },
  },

  service(me, type='ClusterIP'):: $.k('v1', 'Service') + $.metadata(me.pkg, me.namespace) {
    spec+: {
      type: type,
    } + if type == 'ExternalName' then {} else { selector: { app: me.pkg } },
  },

  pdb(me, minAvailable='50%'):: $.k('policy/v1beta1', 'PodDisruptionBudget') + $.metadata(me.pkg, me.namespace) {
    spec+: {
      minAvailable: minAvailable,
      selector: {
        app: me.pkg,
      },
    },
  },

  externalname(me):: $.service(me, type='ExternalName') {
    metadata+: {
      namespace: if lib.isTrue(me, 'global') then 'global' else me.namespace,
    },
    spec+: {
      externalName: me.target.name,
      ports: [
        {
          port: lib.getElse(me, 'expose.port', me.target.port),
          protocol: 'TCP',
          targetPort: me.target.port,
        },
      ],
    },
  },

  storageclass(me):: $.k('storage.k8s.io/v1', 'StorageClass') + $.metadata(me.pkg, me.namespace),

  pvc(me, storage='', storageClassName='gp2-expanding'):: $.k('v1', 'PersistentVolumeClaim') + $.metadata(me.pkg, me.namespace) {
    spec+: {
      accessModes: [
        'ReadWriteOnce',
      ],
      storageClassName: storageClassName,
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


  // Turn a container object or a map of objects into an array of containers with name fields
  // Add name if missing
  toContainerList(me, c)::
    $.withNamesAndImagePullPolicies(
      if std.isArray(c) then c
      else if std.objectHas(c, 'image') && std.isString(c.image)
      then [c { name: lib.getElse(c, 'name', me.pkg) } ]
      else lib.asArrayWithField(c, 'name')
    ),

  // add names and image pull policy to containers
  withNamesAndImagePullPolicies(containers)::
    std.map(function(c) $.withImagePullPolicy(c), containers),

  toleration(key='role', operator='Equal', value='monitoring', effect='NoSchedule'):: {
    key: key,
    operator: operator,
    value: value,
    effect: effect,
  },

  nodeAffinity(key='role', operator='In', values=['monitoring']):: {
    requiredDuringSchedulingIgnoredDuringExecution: {
      nodeSelectorTerms: [{
        matchExpressions: [
          {
            key: key,
            operator: operator,
            values: values,
          },
        ],
      }],
    },
  },

  // all containers in a K8s manifest
  containers(manifest):: (
    if ! std.objectHas(manifest, 'kind') then []
    else if manifest.kind == 'Deployment' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Daemonset' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Statefulset' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Pod' then manifest.spec.containers
    else []),
}

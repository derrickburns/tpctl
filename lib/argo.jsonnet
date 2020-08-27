local global = import 'global.jsonnet';
local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  serviceAccount(me):: k8s.serviceaccount(me) {
    metadata: {
      name: 'argo-workflow',
      namespace: me.namespace,
    },
  },

  clusterRole(me):: k8s.clusterrole(me) {
    metadata: {
      name: 'argo-workflow',
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods',
        ],
        verbs: [
          'get',
          'watch',
          'patch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods/log',
        ],
        verbs: [
          'get',
          'watch',
        ],
      },
    ],
  },

  roleBinding(me, name='argo-workflow', subject_name='argo-workflow', role_name='argo-workflow'):: k8s.rolebinding(me) {
    metadata: {
      name: name,
      namespace: me.namespace,
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: role_name,
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: subject_name,
        namespace: me.namespace,
      },
    ],
  },

  defaultSa(me):: [
    $.serviceAccount(me),
    $.clusterRole(me),
    $.roleBinding(me),
  ],
}

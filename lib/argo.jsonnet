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

  role(me):: k8s.role(me) {
    metadata: {
      name: 'argo-workflow',
      namespace: me.namespace,
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

  roleBinding(me):: k8s.rolebinding(me) {
    metadata: {
      name: 'argo-workflow',
      namespace: me.namespace,
    },
    roleRef+: {
      name: 'argo-workflow',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'argo-workflow',
      },
    ],
  },

  defaultSa(me):: [
    $.serviceAccount(me),
    $.role(me),
    $.roleBinding(me),
  ],
}

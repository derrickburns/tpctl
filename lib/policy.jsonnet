local k8s = import 'k8s.jsonnet';

{
  attachPolicy(allowed):: {
    attachPolicy+: {
      Statement+: allowed,
      Version: '2012-10-17',
    },
  },

  statement(resources, actions):: {
    Effect: 'Allow',
    Resource: resources,
    Action: actions,
  },

  policyAndMetadata(name, namespace, policy):: policy + k8s.metadata(name, namespace),
}

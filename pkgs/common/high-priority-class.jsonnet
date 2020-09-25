{
  apiVersion: 'scheduling.k8s.io/v1',
  description: 'This priority class should be used for pods that block other pods in starting',
  globalDefault: false,
  kind: 'PriorityClass',
  metadata: {
    name: 'high-priority',
  },
  value: 1000000,
}

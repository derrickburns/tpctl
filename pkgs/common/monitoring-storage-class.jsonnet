{
  allowVolumeExpansion: true,
  allowedTopologies: [
    {
      matchLabelExpressions: [
        {
          key: 'role',
          values: [
            'monitoring',
          ],
        },
      ],
    },
  ],
  apiVersion: 'storage.k8s.io/v1',
  kind: 'StorageClass',
  metadata: {
    name: 'monitoring-expanding',
  },
  parameters: {
    fsType: 'ext4',
    type: 'gp2',
  },
  provisioner: 'kubernetes.io/aws-ebs',
  reclaimPolicy: 'Retain',
  volumeBindingMode: 'WaitForFirstConsumer',
}

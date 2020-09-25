{
  apiVersion: 'policy/v1beta1',
  kind: 'PodSecurityPolicy',
  metadata: {
    name: 'sysctl-psp',
  },
  spec: {
    allowPrivilegeEscalation: true,
    allowedCapabilities: [
      'NET_BIND_SERVICE',
      'NET_ADMIN',
      'NET_RAW',
    ],
    allowedUnsafeSysctls: [
      'net.netfilter.nf_conntrack_tcp_timeout_close_waits',
    ],
    fsGroup: {
      ranges: [
        {
          max: 65535,
          min: 0,
        },
      ],
      rule: 'MustRunAs',
    },
    runAsUser: {
      rule: 'RunAsAny',
    },
    seLinux: {
      rule: 'RunAsAny',
    },
    supplementalGroups: {
      ranges: [
        {
          max: 65535,
          min: 0,
        },
      ],
      rule: 'MustRunAs',
    },
    volumes: [
      'configMap',
      'emptyDir',
      'projected',
      'secret',
      'downwardAPI',
      'persistentVolumeClaim',
    ],
  },
}

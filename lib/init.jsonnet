{
  sysctl: {
    args: [
      '-c',
      'sysctl -w net.netfilter.nf_conntrack_tcp_timeout_close_wait=3600',
    ],
    command: [
      '/bin/sh',
    ],
    image: 'busybox:1.29',
    name: 'sysctl-buddy',
    resources: {
      requests: {
        cpu: '1m',
        memory: '1Mi',
      },
    },
    securityContext: {
      privileged: true,
    },
  },
}

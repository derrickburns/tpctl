local lib = import '../lib/lib.jsonnet';

local expand = import '../lib/expand.jsonnet';

local update(config, prev) = prev {
  metadata+: {
    annotations+: {
      'external-dns.alpha.kubernetes.io/alias': 'true',
      'external-dns.alpha.kubernetes.io/hostname': std.join(',', ['*.%s' % config.cluster.metadata.domain] + lib.dnsNames(expand.expandConfig(config))]),
      'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
    },
  },
};

function(config, prev) update(config, prev)

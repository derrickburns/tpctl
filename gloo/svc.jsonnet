local lib = import 'lib.jsonnet';

local update(config, prev) =  prev + {
  metadata+: {
    annotations+: {
      'external-dns.alpha.kubernetes.io/alias': 'true',
      'service.beta.kubernetes.io/aws-load-balancer-type': nlb,
      'external-dns.alpha.kubernetes.io/hostname': lib.dnsNames(config),
      'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': "cluster:%s" % config.cluster.metadata.name
    }
  }
};

function(config, prev) update(config, prev)

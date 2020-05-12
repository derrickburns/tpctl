{
  tcpLoadBalancer(config):: { 
    'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
    'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'tcp',
    'service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled': 'true',
    'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
  }
}

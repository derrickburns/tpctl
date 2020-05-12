{
  externalDnsHosts(hosts):: { 
    'external-dns.alpha.kubernetes.io/alias': 'true',
    'external-dns.alpha.kubernetes.io/hostname': std.join(',', hosts),
  }
}

local lib = import '../../lib/lib.jsonnet';

local tracing = import '../tracing/lib.jsonnet';

{
  annotations(config)::  
    if ! lib.getElse(config, 'pkgs.linkerd.enabled', false)
    then {}
    else {
      'linkerd.io/inject': 'enabled',

      'config.linkerd.io/proxy-log-level': 'warn,linkerd2_proxy=info,linkerd2_proxy::proxy::canonicalize=debug,linkerd2_proxy::dns=debug,trust_dns_resolver=debug',

    } + (if lib.getElse(config, 'pkgs.tracing.enabled', false)
        then { 'config.linkerd.io/trace-collector': tracing.address(config) }
        else {}),
}


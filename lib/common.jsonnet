{
   init(config, prev, namespace, pkg):: {
     _config:: config,
     _prev:: prev,
     _namespace: namespace,
     _pkg: pkg,
     _k8s:: import 'k8s.jsonnet',
     _lib:: import 'lib.jsonnet',
     _flux:: import 'flux.jsonnet',
     _certmanager:: import 'certmanager.jsonnet',
     _global:: import 'global.jsonnet',
     _gloo:: import 'gloo.jsonnet',
     _linkerd:: import 'linkerd.jsonnet',
     _pom:: import 'pom.jsonnet',
     _prom:: import 'promtheus.jsonnet',
     _tracing:: import 'tracing.jsonnet'
   }
}

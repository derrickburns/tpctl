local kubecfg = import 'kubecfg.libsonnet';
local lib = import 'lib.jsonnet';
local exp = import 'expand.jsonnet';

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
    _tracing:: import 'tracing.jsonnet',
    _me:: $.package(config, namespace, pkg),
    _isEnabled(x):: self._global.isEnabled(self._config, x),
  },

  package(config, prev, namespace, pkg):: (
    local expanded = exp.expand(config);
    local me = lib.getElse(expanded, 'namespaces.' + namespace + '.' + pkg, {});
    me {
      namespace:: lib.kebabCase(namespace),
      pkg:: lib.kebabCase(lib.getElse(me, 'pkg', pkg)),
      config: expanded,
      prev:: lib.removeNulls(kubecfg.parseYaml(prev)),
    }
  ),

  namespaces(config):: std.set(std.objectFields(config.namespaces)),

  namespacesWithout(config, prop, default):: (
    local all = $.namespaces(config);
    local on = $.namespacesWith(config, prop, default);
    std.setDiff(all, on)
  ),

  namespacesWith(config, prop, default):: (
    local all = $.namespaces(config);
    std.set(std.filter(function(x) lib.getElse(config.namespaces[x], 'namespace.' + prop, default), all))
  ),
}

local lib = import 'lib.jsonnet';

{
  isEnabled(config, x):: lib.isEnabled($.package(config, x)),

  package(config, x):: (
    local matches = $.packagesWithFilter( 
      config, 
      function(me, config, namespace, pkg) lib.isTrue(me, 'global') && pkg == x);
    assert std.length(matches) <= 1: std.manifestJson( { err: "missing global package", pkg: x, config: config } );
    if std.length(matches) == 0 then null else matches[0];
  ),

  packagesWithFilter(config, filter):: [
    lib.package(config, namespace, pkg)
    for namespace in std.objectFields(config.namespaces)
    for pkg in std.objectFields(config.namespaces[namespace])
    if filter(config.namespaces[namespace][pkg], config, namespace, pkg)
  ],

  packagesWithKey(config, key):: 
    $.packagesWithFilter(config, function(me, config, namespace, pkg) std.objectHas(me, key)),

}

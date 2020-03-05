local gloo = import '../../lib/gloo.jsonnet';

function(config, prev, namespace) (
  local result = gloo.certificatesForPackage(config, 'linkerd-web', namespace);
  assert false: std.manifestJson( {result: result} );
  std.manifestYamlStream(result)
)

local gloo = import '../../lib/gloo.jsonnet';

function(config, prev) 
  std.manifestYamlStream(gloo.certificatesForPackage(config, "linkerd-web"))

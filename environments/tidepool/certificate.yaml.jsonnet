local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace) lib.certificate(config.environments[namespace].tidepool.ingress, namespace)

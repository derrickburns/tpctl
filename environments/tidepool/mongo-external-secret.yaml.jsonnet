local es = import '../external-secrets/lib.jsonnet';

function(config, prev, namespace) es.externalSecret(config, 'mongo', namespace)

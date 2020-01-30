local es = import '../external-secrets/lib.jsonnet';

function(config, prev) es.externalSecret(config, 'mongomirror', 'mongomirror')

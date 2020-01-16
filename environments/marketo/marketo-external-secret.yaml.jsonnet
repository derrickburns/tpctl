local es = import '../../pkgs/external-secrets/lib.jsonnet';

function(config, prev, namespace) es.externalSecret(config, 'marketo', namespace)

local lib = import 'lib.jsonnet';

{
  metadata(automated=true, pattern='glob:master-*'):: {
    local this = self,
    metadata+: {
      annotations+: {
                      'fluxcd.io/automated': if automated then 'true' else 'false',
                    } +
                    {
                      ['fluxcd.io/tag.%s' % container.name]: pattern
                      for container in
                        lib.getElse(this.spec.template.spec.containers, [])
                    },
    },
  },
}

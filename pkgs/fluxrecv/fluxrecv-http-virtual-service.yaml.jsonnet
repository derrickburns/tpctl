local lib = import '../../lib/lib.jsonnet';

function(config) 
  if lib.isTrue(config, 'pkgs.fluxrecv.charts.spec.ingress.service.http.enabled')
  then lib.virtualService('fluxrecv', 'flux', config.pkgs.fluxrecv.charts.spec.ingress, "http")
  else {}
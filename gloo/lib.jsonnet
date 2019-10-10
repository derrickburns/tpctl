{
  get(x, path, sep='.'):: (
    local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
    std.foldl(foldFunc, std.split(path, sep), x)
  ),

  getElse(x, path, default):: (
    local found = $.get(x, path);
    if found == null then default else found
  ),

  isEq(x, path, y):: $.get(x, path) == y,

  isTrue(x, path):: $.isEq(x, path, true),

  dnsNames(config):: (
    local e = $.get(config, 'environments');
    if e == null
    then 'none'
    else (
      local envs = std.objectFields(e);
      local tp = [e[env].tidepool for env in envs if $.isTrue(e[env], 'tidepool.enabled')];
      local httpNames = [x.gateway.http.dnsNames for x in tp if $.isTrue(x, 'gateway.http.enabled')];
      local httpsNames = [x.gateway.https.dnsNames for x in tp if $.isTrue(x, 'gateway.https.enabled')];
      std.join(',', std.filter(function(x) x != 'localhost', std.flattenArrays(httpNames + httpsNames)))
    )
  ),
}

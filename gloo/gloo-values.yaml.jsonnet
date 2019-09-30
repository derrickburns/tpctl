local get(x, path, sep='.') = (
  local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
  std.foldl(foldFunc, std.split(path, sep), x)
);

local getElse(x, path, default) = (
  local found = get(x, path);
  if found == null then default else found
);

local isEq(x, path, y) = get(x,path) == y;

local isTrue(x, path) = isEq(x, path, true);


local dnsNames(config) = (
  local e = get(config, 'environments');
  if e == null
  then "none"
  else (
    local envs = std.objectFields(e);
    local tp = [ e[env].tidepool for env in envs if isTrue(e[env], "tidepool.enabled") ];
    local httpNames = [ x.gateway.http.dnsNames for x in tp if isTrue(x, 'gateway.http.enabled') ];
    local httpsNames = [ x.gateway.https.dnsNames for x in tp if isTrue(x, 'gateway.https.enabled') ];
    std.join(",", std.filter(function(x) x != "localhost", std.flattenArrays(httpNames + httpsNames)))
  )
);

local values(config) = {
      settings: {
        create: false,
      },
      discovery: {
        fdsMode: 'WHITELIST',
      },
      gatewayProxies: {
        gatewayProxyV2: {
          readConfig: true,
          service: {
            extraAnnotations: {
              'service.beta.kubernetes.io/aws-load-balancer-type': 'nlb',
              'external-dns.alpha.kubernetes.io/alias': 'true',
              'external-dns.alpha.kubernetes.io/hostname': dnsNames(config),
              'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,

            },
          },
        },
    },
};

function(config) values(config)

local secret(config) = {
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: config.pkgs.fluxcloud.secret,
    namespace: "flux",
  },
  data: {
    url: '',
  },
};

function(config) secret(config)

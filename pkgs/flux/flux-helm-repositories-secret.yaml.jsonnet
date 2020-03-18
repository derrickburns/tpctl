local info = {
  apiVersion: 'v1',
  repositories: [
    {
      caFile: '',
      cache: 'pomerium-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'pomerium',
      password: '',
      url: 'https://helm.pomerium.io',
      username: '',
    },
    {
      caFile: '',
      cache: 'stable-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'stable',
      password: '',
      url: 'https://kubernetes-charts.storage.googleapis.com',
      username: '',
    },
    {
      caFile: '',
      cache: 'gloo-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'gloo',
      password: '',
      url: 'https://storage.googleapis.com/solo-public-helm',
      username: '',
    },
    {
      caFile: '',
      cache: 'kube-eagle-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'kube-eagle',
      password: '',
      url: 'https://raw.githubusercontent.com/google-cloud-tools/kube-eagle-helm-chart/master',
      username: '',
    },
    {
      caFile: '',
      cache: 'supergloo-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'supergloo',
      password: '',
      url: 'http://storage.googleapis.com/supergloo-helm',
      username: '',
    },
    {
      caFile: '',
      cache: 'jetstack-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'jetstack',
      password: '',
      url: 'https://charts.jetstack.io',
      username: '',
    },
    {
      caFile: '',
      cache: 'es-operator-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'es-operator',
      password: '',
      url: 'https://raw.githubusercontent.com/upmc-enterprises/elasticsearch-operator/master/charts/',
      username: '',
    },
    {
      caFile: '',
      cache: 'banzaicloud-stable-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'banzaicloud-stable',
      password: '',
      url: 'https://kubernetes-charts.banzaicloud.com',
      username: '',
    },
    {
      caFile: '',
      cache: 'stakater-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'stakater',
      password: '',
      url: 'https://stakater.github.io/stakater-charts',
      username: '',
    },
    {
      caFile: '',
      cache: 'solo-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'solo',
      password: '',
      url: 'https://storage.googleapis.com/solo-public-helm/',
      username: '',
    },
    {
      caFile: '',
      cache: 'fluxcd-index.yaml',
      certFile: '',
      keyFile: '',
      name: 'fluxcd',
      password: '',
      url: 'https://fluxcd.github.io/flux',
      username: '',
    },
  ],
};

local fluxHelmRepos(namespace) = {
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: 'flux-helm-repositories',
    namespace: namespace,
  },
  type: 'Opaque',
  data: {
    'repositories.yaml': std.base64(std.manifestJson(info)),
  },
};

function(config, prev, namespace, pkg) fluxHelmRepos(namespace)

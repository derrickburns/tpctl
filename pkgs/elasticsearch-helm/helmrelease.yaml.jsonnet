local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local name = 'elasticsearch';

local helmrelease(me) = k8s.helmrelease(me, { name: name, version: lib.getElse(me, 'version', '7.8.0'), repository: 'https://helm.elastic.co' }) {
  metadata+: {
    name: name,
    labels: {
      app: name,
    },
  },
  spec+: {
    releaseName: name,
    chart+: {
      name: name,
    },
    values+: {
      imageTag: '7.8.0',
      replicas: 1,
      extraEnv: {
        ELASTIC_USERNAME: 'admin',
        ELASTIC_PASSWORD: 'tidepool',
      },
      resources: {
        requests: {
          cpu: '0.3',
          memory: '1Gi',
        },
        limits: {
          cpu: '0.6',
          memory: '2Gi',
        },
      },
      volumeClaimTemplate: {
        accessModes: ['ReadWriteOnce'],
        storageClassName: 'monitoring-expanding',
        resources: {
          requests: {
            storage: lib.getElse(me, 'storage', '5Gi'),
          },
        },
      },
      secretMounts: [{
        name: 'elastic-certificates',
        secretName: 'elasticsearch-tls',
        path: '/usr/share/elasticsearch/config/certs',
      }],
      protocol: 'https',
      esConfig: {
        'elasticsearch.yml': std.manifestYamlDoc({
          'xpack.security.enabled': true,
          'xpack.security.transport.ssl.enabled': true,
          'xpack.security.transport.ssl.verification_mode': 'certificate',
          'xpack.security.transport.ssl.keystore.path': '/usr/share/elasticsearch/config/certs/elastic-certificates.p12',
          'xpack.security.transport.ssl.truststore.path': '/usr/share/elasticsearch/config/certs/elastic-certificates.p12',
          'xpack.security.http.ssl.enabled': true,
          'xpack.security.http.ssl.truststore.path': '/usr/share/elasticsearch/config/certs/elastic-certificates.p12',
          'xpack.security.http.ssl.keystore.path': '/usr/share/elasticsearch/config/certs/elastic-certificates.p12',
        }),
      },
      tolerations: [k8s.toleration()],
      nodeAffinity: k8s.nodeAffinity(),
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

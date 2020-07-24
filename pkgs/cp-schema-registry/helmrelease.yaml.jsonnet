local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { path: 'charts/cp-schema-registry', git: 'git@github.com:tidepool-org/ksql-tools' }) {
  spec+: {
    values: {
      kafka: {
        bootstrapServers: 'PLAINTEXT://kafka-kafka-bootstrap.%s.svc.cluster.local:9092' % me.namespace
      },
    }
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

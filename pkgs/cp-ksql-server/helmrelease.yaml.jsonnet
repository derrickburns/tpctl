local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { path: 'charts/cp-ksql-server', git: 'git@github.com:tidepool-org/ksql-tools' }) {
  spec+: {
    values: {
      external: {
        type: "ClusterIP",
      },
      imageTag: '5.4.2',
      kafka: {
        bootstrapServers: 'PLAINTEXT://kafka-kafka-bootstrap.%s.svc.cluster.local:9092' % me.namespace,
      },
      'cp-zookeeper' : {
         url: 'kafka-zookeeper-client.%s.svc.cluster.local' % me.namespace,
      },
      'cp-schema-registry': {
	url: "cp-schema-registry.%s.svc.cluster.local:8081" % me.namespace,
      },
    }
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))

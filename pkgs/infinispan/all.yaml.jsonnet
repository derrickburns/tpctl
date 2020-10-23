local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local infinispanxml = importstr 'infinispan.xml';
local configmap(me) = k8s.configmap(me) + {
  data: {
    'infinispan.xml': infinispanxml
  }
};

local volumes(me) = [
  { name: 'config', configMap: { name: lib.getElse(me, 'configmap.name', 'infinispan') } },
  { name: 'configtmp', emptyDir: {} }
];

local statefulset(me) = k8s.statefulset(me, [], volumes(me)) {
  spec+: {
    replicas: lib.getElse(me, 'replicas', 2),
    template+: {
      metadata+: {
        name: me.pkg,
      },
      spec+:{
        securityContext: {
          fsGroup: 1000
        },
        initContainers: [
          {
            name: "copy-config",
            image: "busybox",
            command: ["sh", "-c", "cp /config-ro/* /config/; chown 1000 /config/* ; chmod g+w /config/*"],
            volumeMounts: [
              {
                name: "configtmp",
                mountPath: "/config"
              },
              {
                name: "config",
                mountPath: "/config-ro"
              }
            ],
          }
        ],
        containers: [{
          args: ["-c", "/opt/infinispan/server/conf/infinispan.xml"],
          command: ["/opt/infinispan/bin/server.sh"],
          env: [
            k8s.envField("POD_NAME", "metadata.name"),
            k8s.envField("KUBERNETES_NAMESPACE", "metadata.namespace"),
            {
              name: "JAVA_OPTS_EXTRA",
              value: std.join(" ", [
                "-Dinfinispan.cluster.stack=kube",
                "-Dinfinispan.node.name=$(POD_NAME)",
                "-Djboss.tx.node.id=$(POD_NAME)",
                "-Dinfinispan.cluster.name=" + me.pkg,
                "-Djgroups.dns.query=" + me.pkg + ".$(KUBERNETES_NAMESPACE).svc.cluster.local"
              ]),
            },
          ],
          image: "infinispan/server:11.0.4.Final",
          livenessProbe: {
            failureThreshold: 5,
            httpGet: {
              path: "rest/v2/cache-managers/default/health/status",
              port: 11222,
              scheme: "HTTP",
            },
            initialDelaySeconds: 20,
            periodSeconds: 60,
            successThreshold: 1,
            timeoutSeconds: 300,
          },
          name: "infinispan-server",
          ports: [
            { containerPort: 8888, name: "ping", protocol: "TCP" },
            { containerPort: 11222, name: "hotrod", protocol: "TCP" },
          ],
          readinessProbe: {
            failureThreshold: 5,
            httpGet: {
              path: "rest/v2/cache-managers/default/health/status",
              port: 11222,
              scheme: "HTTP",
            },
            initialDelaySeconds: 20,
            periodSeconds: 10,
            successThreshold: 1,
            timeoutSeconds: 300,
          },
          resources: lib.getElse(me, 'resources', {
            requests: {
              cpu: '200m',
              memory: '512Mi'
            }
          }),
          volumeMounts: [
            {
             mountPath: "/opt/infinispan/server/conf/infinispan.xml",
             name: "configtmp",
             subPath: lib.getElse(me, 'configmap.config-xml-key', "infinispan.xml"),
            },
            {
             mountPath: "/opt/infinispan/server/data",
             name: "data"
            }
          ]
        }],
      },
    },
    volumeClaimTemplates: [
      {
        metadata: { name: "data" },
        spec: {
          accessModes: lib.getElse(me, 'storage.accessModes', ["ReadWriteOnce"]),
          storageClassName: lib.getElse(me, 'storage.storageClassName', 'gp2-expanding'),
          resources: {
            requests: {
              storage: lib.getElse(me, 'storage.capacity', '5Gi')
            }
          }
        }
      }
    ]
  },
};

local serviceHotRod(me) = k8s.service(me) + k8s.metadata(me.pkg + '-hotrod', me.namespace) + {
  ports: [ k8s.port(11222, 11222, 'hotrod', 'TCP') ]
};

local serviceHeadless(me) = k8s.service(me) + {
  clusterIP: 'None',
  ports: [ k8s.port(8888, 8888, 'ping', 'TCP') ]
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
    statefulset(me),
    serviceHeadless(me),
    serviceHotRod(me),
  ]
)

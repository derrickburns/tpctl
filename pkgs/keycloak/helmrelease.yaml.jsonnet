local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local remote_infinispan = importstr './remote-infinispan.cli';

local helmrelease(me) = (
  k8s.helmrelease(me, { version: '9.0.1', repository: 'https://codecentric.github.io/helm-charts' }) {
    spec+: {
      values+: {
        image: {
          tag: '11.0.0',
        },
        replicas: 1,
        imagePullSecrets: [],
        postgresql: {
          enabled: false,
        },
        startupScripts: {
          'remote-infinispan.cli': remote_infinispan,
        },
        serviceAccount: {
          create: true,
          name: me.pkg,
        },
        rbac: {
          create: true,
          rules: [
            {
              apiGroups: [''],
              resources: [
                'pods'
              ],
              verbs: [
                'get',
                'list',
                'watch',
              ],
            },
          ],
        },
        extraEnv: std.manifestYamlDoc(
          [
            {
              name: 'DB_VENDOR',
              value: 'postgres',
            },
            {
              name: 'DB_PORT',
              value: '5432',
            },
            {
              name: 'DB_ADDR',
              value: me.rds_address,
            },
            {
              name: 'DB_DATABASE',
              value: me.pkg,
            },
            {
              name: 'CACHE_OWNERS',
              value: '2',
            },
            {
              name: 'PROXY_ADDRESS_FORWARDING',
              value: 'true',
            },
            {
              name: 'KUBERNETES_NAMESPACE',
              valueFrom: {
                fieldRef: {
                  fieldPath: 'metadata.namespace',
                },
              },
            },
            {
              name: 'POD_NAME',
              valueFrom: {
                fieldRef: {
                  apiVersion: 'v1',
                  fieldPath: 'metadata.name',
                },
              },
            },
            {
              name: 'JAVA_OPTS',
              value: '-server -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Djboss.default.jgroups.stack=kubernetes -Djboss.node.name=$(POD_NAME) -Djboss.tx.node.id=$(POD_NAME) -Djboss.site.name=$(KUBERNETES_NAMESPACE) -Dremote.cache.host=infinispan-server-hotrod.infinispan.svc.cluster.local -Dkeycloak.connectionsInfinispan.hotrodProtocolVersion=2.8'
            }
          ],
          indent_array_in_object=false
        ),
        extraInitContainers: std.manifestYamlDoc(
          [
            {
              name: 'rest-provider',
              image: 'busybox',
              imagePullPolicy: 'IfNotPresent',
              command: ['wget', '-O', '/deployments/keycloak-rest-provider-0.1.jar', 'https://github.com/toddkazakov/keycloak-user-migration/releases/download/0.1/keycloak-rest-provider-0.1.jar'],
              volumeMounts: [
                {
                  name: 'extensions',
                  mountPath: '/deployments',
                },
              ],
            },
            {
              name: 'tidepool-extensions',
              image: 'busybox',
              imagePullPolicy: 'IfNotPresent',
              command: ['wget', '-O', '/deployments/admin-0.0.3.jar', 'https://github.com/tidepool-org/keycloak-extensions/releases/download/0.0.3/admin-0.0.3.jar'],
              volumeMounts: [
                {
                  name: 'extensions',
                  mountPath: '/deployments',
                },
              ],
            },
            {
              name: 'prometheus-metrics',
              image: 'busybox',
              imagePullPolicy: 'IfNotPresent',
              command: ['wget', '-O', '/deployments/keycloak-metrics-spi.jar', 'https://github.com/aerogear/keycloak-metrics-spi/releases/download/1.0.1/keycloak-metrics-spi-1.0.1.jar'],
              volumeMounts: [
                {
                  name: 'extensions',
                  mountPath: '/deployments',
                },
              ],
            },
          ],
          indent_array_in_object=false
        ),
        extraVolumes: std.manifestYamlDoc(
          [
            {
              name: 'extensions',
              emptyDir: {},
            },
          ],
          indent_array_in_object=false
        ),
        extraVolumeMounts: std.manifestYamlDoc(
          [
            {
              name: 'extensions',
              mountPath: '/opt/jboss/keycloak/standalone/deployments',
            },
          ],
          indent_array_in_object=false
        ),
        serviceMonitor: {
          enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
          path: '/auth/realms/master/metrics',
          port: 'http',
        },
        extraEnvFrom: std.manifestYamlDoc(
          [
            {
              secretRef: {
                name: me.pkg,
              },
            },
          ], indent_array_in_object=false
        ),
      },
    },
  }
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)

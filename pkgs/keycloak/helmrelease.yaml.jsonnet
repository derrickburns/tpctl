local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local remote_infinispan = importstr './remote-infinispan.cli';
local local_infinispan = importstr './local-infinispan.cli';

local helmrelease(me) = (
  k8s.helmrelease(me, { version: '9.0.1', repository: 'https://codecentric.github.io/helm-charts' }) {
    spec+: {
      values+: {
        image: {
          tag: '11.0.0',
        },
        replicas: 4,
        imagePullSecrets: [],
        postgresql: {
          enabled: false,
        },
        startupScripts: {
          'local-infinispan.cli': local_infinispan,
        },
        resources: {
          requests: {
            memory: '1280Mi',
          },
          limits: {
            memory: '2048Mi',
          },
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
              name: 'CACHE_OWNERS_COUNT',
              value: '2',
            },
            {
              name: 'CACHE_OWNERS_AUTH_SESSIONS_COUNT',
              value: '2',
            },
            {
              name: 'PROXY_ADDRESS_FORWARDING',
              value: 'true',
            },
            {
              name: 'KEYCLOAK_STATISTICS',
              value: 'all',
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
              name: 'JGROUPS_DISCOVERY_PROTOCOL',
              value: 'dns.DNS_PING',
            },
            {
              name: 'JGROUPS_DISCOVERY_PROPERTIES',
              value: 'dns_query=keycloak-headless.'+me.namespace+'.svc.cluster.local',
            },
            {
              name: 'JAVA_OPTS',
              value: std.join(' ', [
                '-server',
                '-XX:+UseContainerSupport',
                '-XX:MaxRAMPercentage=75.0',
                '-Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS',
                '-Djava.net.preferIPv4Stack=true',
                '-Djava.awt.headless=true',
                '-Djboss.node.name=$(POD_NAME)',
                '-Djboss.tx.node.id=$(POD_NAME)',
                '-Djboss.site.name=' + me.namespace,
                '-Dremote.cache.host=infinispan-hotrod.infinispan.svc.cluster.local',
                '-Dkeycloak.connectionsInfinispan.hotrodProtocolVersion=2.8',
                '-Dorg.wildfly.sigterm.suspend.timeout=120',
                '-Djboss.as.management.blocking.timeout=1200',
              ]),
            }
          ],
          indent_array_in_object=false
        ),
        livenessProbe: std.manifestYamlDoc({
          httpGet: {
            path: '/auth/',
            port: 'http',
          },
          initialDelaySeconds: 1200,
          timeoutSeconds: 20,
        }),
        terminationGracePeriodSeconds: 120,
        podDisruptionBudget: {
          maxUnavailable: 1,
        },
        // SET FOR PRODUCTION podManagementPolicy: 'OrderedReady',
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
        extraServiceMonitor: {
          enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
          path: '/auth/realms/master/metrics',
          port: 'http',
        },
        serviceMonitor: {
          enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
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

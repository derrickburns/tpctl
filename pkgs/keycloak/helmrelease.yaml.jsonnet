local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local remote_infinispan = importstr './remote-infinispan.cli';
local local_infinispan = importstr './local-infinispan.cli';

local imagerepo = 'docker.io/jboss/keycloak';
local imagetag = '11.0.0';

local helmrelease(me) = (
  k8s.helmrelease(me, { version: '9.5.0', repository: 'https://codecentric.github.io/helm-charts' }) {
    spec+: {
      values+: {
        image: {
          repository: imagerepo,
          tag: imagetag,
        },
        replicas: 3,
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
              value: '3',
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
              name: 'KEYCLOAK_INFINISPAN_SESSIONS_PER_SEGMENT',
              value: lib.getElse(me, 'offlineSessionsPerSegment', '512'),
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
                '-Dwildfly.infinispan.statistics-enabled=true',
                '-Dwildfly.undertow.statistics-enabled=true',
                '-Dorg.wildfly.sigterm.suspend.timeout=' + lib.getElse(me, 'terminationGracePeriodSeconds', '120'),
                '-Djboss.as.management.blocking.timeout=' + lib.getElse(me, 'initTimeout', '600'),
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
          initialDelaySeconds: std.parseInt(lib.getElse(me, 'initTimeout', '600')),
          timeoutSeconds: 20,
        }),
        terminationGracePeriodSeconds: std.parseInt(lib.getElse(me, 'terminationGracePeriodSeconds', '120')),
        podDisruptionBudget: {
          maxUnavailable: 1,
        },
        podManagementPolicy: 'OrderedReady',
        extraInitContainers: std.manifestYamlDoc(
          [
            {
              name: 'init-config',
              image: imagerepo + ':' + imagetag,
              imagePullPolicy: 'IfNotPresent',
              command: ['/bin/bash', '-c', 'cp -R /opt/jboss/keycloak/standalone/configuration/* /configuration && cp /custom/standalone-ha.xml /custom/jmx_exporter.yaml /configuration'],
              volumeMounts: [
                {
                  name: 'configuration',
                  mountPath: '/configuration',
                },
                {
                  name: 'custom-configuration',
                  mountPath: '/custom',
                },
              ],
            },
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
              command: [
                '/bin/sh',
                '-c',
                std.join(' && ', [
                  'wget -O /deployments/admin-0.0.4.jar https://github.com/tidepool-org/keycloak-extensions/releases/download/0.0.4/admin-0.0.4.jar',
                  'wget -O /deployments/jmx-metrics-ear-0.0.4.ear https://github.com/tidepool-org/keycloak-extensions/releases/download/0.0.4/jmx-metrics-ear-0.0.4.ear',
                ]),
              ],
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
            {
              name: 'configuration',
              emptyDir: {},
            },
            {
              name: 'custom-configuration',
              configMap: {
                name: 'custom-configuration'
              },
            }
          ],
          indent_array_in_object=false
        ),
        extraVolumeMounts: std.manifestYamlDoc(
          [
            {
              name: 'extensions',
              mountPath: '/opt/jboss/keycloak/standalone/deployments',
            },
            {
              name: 'configuration',
              mountPath: '/opt/jboss/keycloak/standalone/configuration',
            }
          ],
          indent_array_in_object=false
        ),
        serviceMonitor: {
          enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
          path: '/auth/realms/master/metrics',
          port: 'http',
        },
        extraServiceMonitor: {
          enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
          path: '/auth/realms/master/jmx-metrics',
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

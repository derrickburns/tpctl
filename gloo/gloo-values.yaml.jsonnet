local lib = import '../lib/lib.jsonnet';





local values(config) = {
  apiServer: {
    deployment: {
      envoy: {
        image: {
          pullPolicy: 'IfNotPresent',
          repository: 'grpcserver-envoy',
          tag: '1.0.0-rc5',
        },
      },
      server: {
        grpcPort: 10101,
        image: {
          pullPolicy: 'IfNotPresent',
          repository: 'grpcserver-ee',
          tag: '1.0.0-rc5',
        },
        oauth: {
          client: '',
          server: '',
        },
      },
      ui: {
        image: {
          pullPolicy: 'IfNotPresent',
          repository: 'grpcserver-ui',
          tag: '1.0.0-rc5',
        },
        staticPort: 8080,
      },
    },
    enable: true,
    enableBeta: true,
    enterprise: true,
    service: {
      name: 'apiserver-ui',
    },
  },
  global: {
    extensions: {
      extAuth: {
        deployment: {
          image: {
            pullPolicy: 'IfNotPresent',
            repository: 'extauth-ee',
            tag: '1.0.0-rc5',
          },
          name: 'extauth',
          port: 8083,
          stats: true,
        },
        enabled: true,
        envoySidecar: false,
        service: {
          name: 'extauth',
          port: 8083,
        },
        serviceName: 'ext-auth',
        signingKey: {
          name: 'extauth-signing-key',
          'signing-key': '',
        },
        standaloneDeployment: true,
        userIdHeader: 'x-user-id',
      },
    },
    glooRbac: {
      create: true,
      nameSuffix: '',
      namespaced: false,
    },
    image: {
      pullPolicy: 'IfNotPresent',
      pullSecret: 'solo-io-readerbot-pull-secret',
      registry: 'quay.io/solo-io',
    },
  },
  gloo: {
    namespace: {
      create: false,
    },
  
    gatewayProxies: {
      internalGatewayProxy: {
        antiAffinity: false,
        extraInitContainersHelper: "",
        extraVolumeHelper: "",
        stats: true,
        kind: {
          deployment: {
            replicas: 2,
          },
        },
        configMap: {
          data: null,
        },
        podTemplate: {
          probes: false,
          disableNetBind: false,
          floatingUserId: false,
          httpPort: 8080,
          httpsPort: 8443,
          image: {
            pullPolicy: "IfNotPresent",
            repository: "gloo-ee-envoy-wrapper",
            tag: "1.0.0-rc5",
          },
          runAsUser: 0,
          runUnprivileged: false,
          tolerations: null,
          extraAnnotations: {
            'linkerd.io/inject': 'enabled',
            'config.linkerd.io/skip-inbound-ports': '8081',
          },
        },
        service: {
          type: 'ClusterIP',
          httpPort: 80,
          httpsPort: 443,
          extraAnnotations: {
            'prometheus.io/path': '/metrics',
            'prometheus.io/port': '8081',
            'prometheus.io/scrape': 'true',
        },
        readConfig: true,
        gatewaySettings: {
          disableGeneratedGateways: true,
        },
        tracing: {
          provider: {
            name: 'envoy.zipkin',
            typed_config: {
              '@type': 'type.googleapis.com/envoy.config.trace.v2.ZipkinConfig',
              collector_cluster: 'zipkin',
              collector_endpoint: '/api/v1/spans',
            },
          },
          cluster: [
            {
              name: 'zipkin',
              connect_timeout: '1s',
              type: 'STRICT_DNS',
              load_assignment: {
                cluster_name: 'zipkin',
                endpoints: [
                  {
                    lb_endpoints: [
                      {
                        endpoint: {
                          address: {
                            socket_address: {
                              address: 'simplest-collector',
                              port_value: 9411,
                            },
                          },
                        },
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
      },
      gatewayProxy: {
        antiAffinity: false,
        extraInitContainersHelper: "",
        extraVolumeHelper: "",
        kind: {
          deployment: {
            replicas: 2,
          },
        },
        readConfig: true,
        gatewaySettings: {
          disableGeneratedGateways: true,
        },
        configMap: {
          data: null,
        },
        tracing: {
          provider: {
            name: 'envoy.zipkin',
            typed_config: {
              '@type': 'type.googleapis.com/envoy.config.trace.v2.ZipkinConfig',
              collector_cluster: 'zipkin',
              collector_endpoint: '/api/v1/spans',
            },
          },
          cluster: [
            {
              name: 'zipkin',
              connect_timeout: '1s',
              type: 'STRICT_DNS',
              load_assignment: {
                cluster_name: 'zipkin',
                endpoints: [
                  {
                    lb_endpoints: [
                      {
                        endpoint: {
                          address: {
                            socket_address: {
                              address: 'simplest-collector',
                              port_value: 9411,
                            },
                          },
                        },
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
        podTemplate: {
          probes: false,
          disableNetBind: false,
          floatingUserId: false,
          httpPort: 8080,
          httpsPort: 8443,
          image: {
            pullPolicy: "IfNotPresent",
            repository: "gloo-ee-envoy-wrapper",
            tag: "1.0.0-rc5",
          },
          runAsUser: 0,
          runUnprivileged: false,
          tolerations: null,
          extraAnnotations: {
            'linkerd.io/inject': 'enabled',
            'config.linkerd.io/skip-inbound-ports': '8081',
          },
        },
        service: {
          type: 'LoadBalancer',
          httpPort: 80,
          httpsPort: 443,
          extraAnnotations: {
            'prometheus.io/path': '/metrics',
            'prometheus.io/port': '8081',
            'prometheus.io/scrape': 'true',
            'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
            'external-dns.alpha.kubernetes.io/alias': 'true',
            'external-dns.alpha.kubernetes.io/hostname': lib.dnsNames(config),
            'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
  
          },
        },
      },
    },
    accessLogger: {
      enabled: false,
      image: {
        repository: 'access-logger',
        tag: '1.2.5',
      },
      port: 8083,
      replicas: 1,
      serviceName: 'AccessLog',
    },
    crds: {
      create: false,
    },
    discovery: {
      deployment: {
        floatingUserId: false,
        image: {
          pullPolicy: 'IfNotPresent',
          registry: 'quay.io/solo-io',
          repository: 'discovery',
          tag: '1.2.5',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: false,
      },
      enabled: true,
      fdsMode: '',
    },
    gateway: {
      certGenJob: {
        enabled: true,
        image: {
          pullPolicy: 'IfNotPresent',
          registry: 'quay.io/solo-io',
          repository: 'certgen',
          tag: '1.2.5',
        },
        restartPolicy: 'OnFailure',
        setTtlAfterFinished: true,
        ttlSecondsAfterFinished: 60,
      },
      deployment: {
        floatingUserId: false,
        image: {
          pullPolicy: 'IfNotPresent',
          registry: 'quay.io/solo-io',
          repository: 'gateway',
          tag: '1.2.5',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: false,
      },
      enabled: true,
      proxyServiceAccount: {
        disableAutomount: false,
      },
      readGatewaysFromAllNamespaces: false,
      updateValues: true,
      validation: {
        alwaysAcceptResources: true,
        enabled: true,
        failurePolicy: 'Ignore',
        secretName: 'gateway-validation-certs',
      },
    },
    global: {
      extensions: {
        extAuth: {
          deployment: {
            image: {
              pullPolicy: 'IfNotPresent',
              repository: 'extauth-ee',
              tag: '1.0.0-rc5',
            },
            name: 'extauth',
            port: 8083,
            stats: true,
          },
          enabled: true,
          envoySidecar: false,
          service: {
            name: 'extauth',
            port: 8083,
          },
          serviceName: 'ext-auth',
          signingKey: {
            name: 'extauth-signing-key',
            'signing-key': '',
          },
          standaloneDeployment: true,
          userIdHeader: 'x-user-id',
        },
      },
      glooRbac: {
        create: true,
        nameSuffix: '',
        namespaced: false,
      },
      image: {
        pullPolicy: 'IfNotPresent',
        pullSecret: 'solo-io-readerbot-pull-secret',
        registry: 'quay.io/solo-io',
      },
    },
    gloo: {
      deployment: {
        disableUsageStatistics: false,
        floatingUserId: false,
        image: {
          pullPolicy: 'IfNotPresent',
          repository: 'gloo-ee',
          tag: '1.0.0-rc5',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: true,
        validationPort: 9988,
        xdsPort: 9977,
      },
    },
    ingress: {
      deployment: {
        image: {
          repository: 'ingress',
          tag: '1.2.5',
        },
        replicas: 1,
      },
      enabled: false,
      requireIngressClass: null,
    },
    ingressProxy: {
      configMap: {},
      deployment: {
        httpPort: 80,
        httpsPort: 443,
        image: {
          repository: 'gloo-envoy-wrapper',
          tag: '1.2.5',
        },
        replicas: 1,
      },
    },
    k8s: {
      clusterName: 'cluster.local',
    },
    namespace: {
      create: false,
    },
    settings: {
      linkerd: true,
      integrations: {
        knative: {
          enabled: false,
          proxy: {
            httpPort: 80,
            httpsPort: 443,
            image: {
              repository: 'gloo-envoy-wrapper',
              tag: '1.2.5',
            },
            replicas: 1,
          },
          version: '0.10.0',
        },
      },
      invalidConfigPolicy: {
        invalidRouteResponseBody: 'Gloo Gateway has invalid configuration. Administrators should run `glooctl check` to find and fix config errors.',
        invalidRouteResponseCode: 404,
      },
      singleNamespace: false,
    },
  },
  grafana: {
    admin: {
      existingSecret: '',
      passwordKey: 'admin-password',
      userKey: 'admin-user',
    },
    adminPassword: 'admin',
    adminUser: 'admin',
    affinity: {},
    dashboardProviders: {
      'dashboardproviders.yaml': {
        apiVersion: 1,
        providers: [
          {
            disableDeletion: false,
            editable: true,
            folder: 'gloo',
            name: 'gloo',
            options: {
              path: '/var/lib/grafana/dashboards/gloo',
            },
            orgId: 1,
            type: 'file',
          },
        ],
      },
    },
    dashboards: {},
    dashboardsConfigMaps: {
      gloo: 'glooe-grafana-custom-dashboards',
    },
    datasources: {
      'datasources.yaml': {
        apiVersion: 1,
        datasources: [
          {
            access: 'proxy',
            isDefault: true,
            name: 'gloo',
            type: 'prometheus',
            url: 'http://glooe-prometheus-server:80',
          },
        ],
      },
    },
    defaultInstallationEnabled: true,
    deploymentStrategy: {
      type: 'RollingUpdate',
    },
    downloadDashboards: {
      env: {},
    },
    downloadDashboardsImage: {
      pullPolicy: 'IfNotPresent',
      repository: 'appropriate/curl',
      tag: 'latest',
    },
    env: {},
    envFromSecret: '',
    envRenderSecret: {},
    extraConfigmapMounts: [],
    extraContainers: '',
    extraEmptyDirMounts: [],
    extraInitContainers: [],
    extraSecretMounts: [],
    extraVolumeMounts: [],
    fullnameOverride: 'glooe-grafana',
    global: {
      extensions: {
        extAuth: {
          deployment: {
            image: {
              pullPolicy: 'IfNotPresent',
              repository: 'extauth-ee',
              tag: '1.0.0-rc5',
            },
            name: 'extauth',
            port: 8083,
            stats: true,
          },
          enabled: true,
          envoySidecar: false,
          service: {
            name: 'extauth',
            port: 8083,
          },
          serviceName: 'ext-auth',
          signingKey: {
            name: 'extauth-signing-key',
            'signing-key': '',
          },
          standaloneDeployment: true,
          userIdHeader: 'x-user-id',
        },
      },
      glooRbac: {
        create: true,
        nameSuffix: '',
        namespaced: false,
      },
      image: {
        pullPolicy: 'IfNotPresent',
        pullSecret: 'solo-io-readerbot-pull-secret',
        registry: 'quay.io/solo-io',
      },
    },
    'grafana.ini': {
      analytics: {
        check_for_updates: true,
      },
      grafana_net: {
        url: 'https://grafana.net',
      },
      log: {
        mode: 'console',
      },
      paths: {
        data: '/var/lib/grafana/data',
        logs: '/var/log/grafana',
        plugins: '/var/lib/grafana/plugins',
        provisioning: '/etc/grafana/provisioning',
      },
    },
    image: {
      pullPolicy: 'IfNotPresent',
      repository: 'grafana/grafana',
      tag: '6.4.2',
    },
    ingress: {
      annotations: {},
      enabled: false,
      extraPaths: [],
      hosts: [
        'chart-example.local',
      ],
      labels: {},
      path: '/',
      tls: [],
    },
    initChownData: {
      enabled: true,
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'busybox',
        tag: '1.30',
      },
      resources: {},
    },
    ldap: {
      config: '',
      enabled: false,
      existingSecret: '',
    },
    livenessProbe: {
      failureThreshold: 10,
      httpGet: {
        path: '/api/health',
        port: 3000,
      },
      initialDelaySeconds: 60,
      timeoutSeconds: 30,
    },
    nameOverride: 'glooe-grafana',
    nodeSelector: {},
    notifiers: {},
    persistence: {
      accessModes: [
        'ReadWriteOnce',
      ],
      enabled: true,
      finalizers: [
        'kubernetes.io/pvc-protection',
      ],
      size: '100Mi',
      type: 'pvc',
    },
    plugins: [],
    podDisruptionBudget: {},
    podPortName: 'grafana',
    rbac: {
      create: false,
      extraClusterRoleRules: [],
      extraRoleRules: [],
      namespaced: false,
      pspEnabled: false,
      pspUseAppArmor: true,
    },
    readinessProbe: {
      httpGet: {
        path: '/api/health',
        port: 3000,
      },
    },
    replicas: 1,
    resources: {},
    securityContext: {
      fsGroup: 472,
      runAsUser: 472,
    },
    service: {
      annotations: {},
      labels: {},
      port: 80,
      portName: 'service',
      targetPort: 3000,
      type: 'ClusterIP',
    },
    serviceAccount: {
      create: true,
      name: null,
      nameTest: null,
    },
    sidecar: {
      dashboards: {
        defaultFolderName: null,
        enabled: false,
        folder: '/tmp/dashboards',
        label: 'grafana_dashboard',
        provider: {
          disableDelete: false,
          folder: '',
          name: 'sidecarProvider',
          orgid: 1,
          type: 'file',
        },
        searchNamespace: null,
      },
      datasources: {
        enabled: false,
        label: 'grafana_datasource',
        searchNamespace: null,
      },
      image: 'kiwigrid/k8s-sidecar:0.1.20',
      imagePullPolicy: 'IfNotPresent',
      resources: {},
    },
    smtp: {
      existingSecret: '',
      passwordKey: 'password',
      userKey: 'user',
    },
    testFramework: {
      enabled: false,
      image: 'dduportal/bats',
      securityContext: {},
      tag: '0.4.0',
    },
    tolerations: [],
  },
  observability: {
    customGrafana: {
      apiKey: '',
      enabled: false,
      password: '',
      url: '',
      username: '',
    },
    deployment: {
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'observability-ee',
        tag: '1.0.0-rc5',
      },
    },
    enabled: true,
    upstreamDashboardTemplate: '',
  },
  prometheus: {
    alertmanager: {
      affinity: {},
      baseURL: '/',
      configFileName: 'alertmanager.yml',
      configFromSecret: '',
      configMapOverrideName: '',
      enabled: false,
      extraArgs: {},
      extraEnv: {},
      extraSecretMounts: [],
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'prom/alertmanager',
        tag: 'v0.18.0',
      },
      ingress: {
        annotations: {},
        enabled: false,
        extraLabels: {},
        extraPaths: [],
        hosts: [],
        tls: [],
      },
      name: 'alertmanager',
      nodeSelector: {},
      persistentVolume: {
        accessModes: [
          'ReadWriteOnce',
        ],
        annotations: {},
        enabled: true,
        existingClaim: '',
        mountPath: '/data',
        size: '2Gi',
        subPath: '',
      },
      podAnnotations: {},
      podSecurityPolicy: {
        annotations: {},
      },
      prefixURL: '',
      priorityClassName: '',
      replicaCount: 1,
      resources: {},
      securityContext: {
        fsGroup: 65534,
        runAsGroup: 65534,
        runAsNonRoot: true,
        runAsUser: 65534,
      },
      service: {
        annotations: {},
        clusterIP: '',
        externalIPs: [],
        labels: {},
        loadBalancerIP: '',
        loadBalancerSourceRanges: [],
        servicePort: 80,
        sessionAffinity: 'None',
        type: 'ClusterIP',
      },
      statefulSet: {
        enabled: false,
        headless: {
          annotations: {},
          labels: {},
          servicePort: 80,
        },
        podManagementPolicy: 'OrderedReady',
      },
      tolerations: [],
    },
    alertmanagerFiles: {
      'alertmanager.yml': {
        global: {},
        receivers: [
          {
            name: 'default-receiver',
          },
        ],
        route: {
          group_interval: '5m',
          group_wait: '10s',
          receiver: 'default-receiver',
          repeat_interval: '3h',
        },
      },
    },
    configmapReload: {
      extraArgs: {},
      extraConfigmapMounts: [],
      extraVolumeDirs: [],
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'jimmidyson/configmap-reload',
        tag: 'v0.2.2',
      },
      name: 'configmap-reload',
      resources: {},
    },
    enabled: true,
    global: {
      extensions: {
        extAuth: {
          deployment: {
            image: {
              pullPolicy: 'IfNotPresent',
              repository: 'extauth-ee',
              tag: '1.0.0-rc5',
            },
            name: 'extauth',
            port: 8083,
            stats: true,
          },
          enabled: true,
          envoySidecar: false,
          service: {
            name: 'extauth',
            port: 8083,
          },
          serviceName: 'ext-auth',
          signingKey: {
            name: 'extauth-signing-key',
            'signing-key': '',
          },
          standaloneDeployment: true,
          userIdHeader: 'x-user-id',
        },
      },
      glooRbac: {
        create: true,
        nameSuffix: '',
        namespaced: false,
      },
      image: {
        pullPolicy: 'IfNotPresent',
        pullSecret: 'solo-io-readerbot-pull-secret',
        registry: 'quay.io/solo-io',
      },
    },
    kubeStateMetrics: {
      args: {},
      enabled: true,
      fullnameOverride: 'glooe-prometheus-kube-state-metrics',
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'quay.io/coreos/kube-state-metrics',
        tag: 'v1.6.0',
      },
      name: 'kube-state-metrics',
      nodeSelector: {},
      pod: {
        labels: {},
      },
      podAnnotations: {},
      podSecurityPolicy: {
        annotations: {},
      },
      priorityClassName: '',
      replicaCount: 1,
      resources: {},
      securityContext: {
        runAsNonRoot: true,
        runAsUser: 65534,
      },
      service: {
        annotations: {
          'prometheus.io/scrape': 'true',
        },
        clusterIP: 'None',
        externalIPs: [],
        labels: {},
        loadBalancerIP: '',
        loadBalancerSourceRanges: [],
        servicePort: 80,
        type: 'ClusterIP',
      },
      tolerations: [],
    },
    nameOverride: 'glooe-prometheus',
    networkPolicy: {
      enabled: false,
    },
    nodeExporter: {
      enabled: false,
      extraArgs: {},
      extraConfigmapMounts: [],
      extraHostPathMounts: [],
      hostNetwork: true,
      hostPID: true,
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'prom/node-exporter',
        tag: 'v0.18.0',
      },
      name: 'node-exporter',
      nodeSelector: {},
      pod: {
        labels: {},
      },
      podAnnotations: {},
      podSecurityPolicy: {
        annotations: {},
      },
      priorityClassName: '',
      resources: {},
      securityContext: {},
      service: {
        annotations: {
          'prometheus.io/scrape': 'true',
        },
        clusterIP: 'None',
        externalIPs: [],
        hostPort: 9100,
        labels: {},
        loadBalancerIP: '',
        loadBalancerSourceRanges: [],
        servicePort: 9100,
        type: 'ClusterIP',
      },
      tolerations: [],
      updateStrategy: {
        type: 'RollingUpdate',
      },
    },
    podSecurityPolicy: {
      enabled: false,
    },
    pushgateway: {
      enabled: false,
      extraArgs: {},
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'prom/pushgateway',
        tag: 'v0.8.0',
      },
      ingress: {
        annotations: {},
        enabled: false,
        extraPaths: [],
        hosts: [],
        tls: [],
      },
      name: 'pushgateway',
      nodeSelector: {},
      persistentVolume: {
        accessModes: [
          'ReadWriteOnce',
        ],
        annotations: {},
        enabled: false,
        existingClaim: '',
        mountPath: '/data',
        size: '2Gi',
        subPath: '',
      },
      podAnnotations: {},
      podSecurityPolicy: {
        annotations: {},
      },
      priorityClassName: '',
      replicaCount: 1,
      resources: {},
      securityContext: {
        runAsNonRoot: true,
        runAsUser: 65534,
      },
      service: {
        annotations: {
          'prometheus.io/probe': 'pushgateway',
        },
        clusterIP: '',
        externalIPs: [],
        labels: {},
        loadBalancerIP: '',
        loadBalancerSourceRanges: [],
        servicePort: 9091,
        type: 'ClusterIP',
      },
      tolerations: [],
    },
    rbac: {
      create: true,
    },
    server: {
      affinity: {},
      baseURL: '',
      configMapOverrideName: '',
      configPath: '/etc/config/prometheus.yml',
      emptyDir: {
        sizeLimit: '',
      },
      enableAdminApi: false,
      enabled: true,
      env: {},
      extraArgs: {},
      extraConfigmapMounts: [],
      extraHostPathMounts: [],
      extraInitContainers: [],
      extraSecretMounts: [],
      extraVolumeMounts: [],
      extraVolumes: [],
      fullnameOverride: 'glooe-prometheus-server',
      global: {
        evaluation_interval: '10s',
        scrape_interval: '10s',
        scrape_timeout: '10s',
      },
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'prom/prometheus',
        tag: 'v2.13.1',
      },
      ingress: {
        annotations: {},
        enabled: false,
        extraLabels: {},
        extraPaths: [],
        hosts: [],
        tls: [],
      },
      livenessProbeInitialDelay: 30,
      livenessProbeTimeout: 30,
      name: 'server',
      nodeSelector: {},
      persistentVolume: {
        accessModes: [
          'ReadWriteOnce',
        ],
        annotations: {},
        enabled: true,
        existingClaim: '',
        mountPath: '/data',
        size: '16Gi',
        subPath: '',
      },
      podAnnotations: {},
      podLabels: {},
      podSecurityPolicy: {
        annotations: {},
      },
      prefixURL: '',
      priorityClassName: '',
      readinessProbeInitialDelay: 30,
      readinessProbeTimeout: 30,
      replicaCount: 1,
      resources: {},
      retention: '15d',
      securityContext: {
        fsGroup: 65534,
        runAsGroup: 65534,
        runAsNonRoot: true,
        runAsUser: 65534,
      },
      service: {
        annotations: {},
        clusterIP: '',
        externalIPs: [],
        labels: {},
        loadBalancerIP: '',
        loadBalancerSourceRanges: [],
        servicePort: 80,
        sessionAffinity: 'None',
        type: 'ClusterIP',
      },
      sidecarContainers: null,
      skipTSDBLock: false,
      statefulSet: {
        annotations: {},
        enabled: false,
        headless: {
          annotations: {},
          labels: {},
          servicePort: 80,
        },
        labels: {},
        podManagementPolicy: 'OrderedReady',
      },
      terminationGracePeriodSeconds: 300,
      tolerations: [],
    },
    serverFiles: {
      alerts: {},
      'prometheus.yml': {
        rule_files: [
          '/etc/config/rules',
          '/etc/config/alerts',
        ],
        scrape_configs: [
          {
            job_name: 'prometheus',
            static_configs: [
              {
                targets: [
                  'localhost:9090',
                ],
              },
            ],
          },
          {
            bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',
            job_name: 'kubernetes-apiservers',
            kubernetes_sd_configs: [
              {
                role: 'endpoints',
              },
            ],
            relabel_configs: [
              {
                action: 'keep',
                regex: 'default;kubernetes;https',
                source_labels: [
                  '__meta_kubernetes_namespace',
                  '__meta_kubernetes_service_name',
                  '__meta_kubernetes_endpoint_port_name',
                ],
              },
            ],
            scheme: 'https',
            tls_config: {
              ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
              insecure_skip_verify: true,
            },
          },
          {
            bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',
            job_name: 'kubernetes-nodes',
            kubernetes_sd_configs: [
              {
                role: 'node',
              },
            ],
            relabel_configs: [
              {
                action: 'labelmap',
                regex: '__meta_kubernetes_node_label_(.+)',
              },
              {
                replacement: 'kubernetes.default.svc:443',
                target_label: '__address__',
              },
              {
                regex: '(.+)',
                replacement: '/api/v1/nodes/$1/proxy/metrics',
                source_labels: [
                  '__meta_kubernetes_node_name',
                ],
                target_label: '__metrics_path__',
              },
            ],
            scheme: 'https',
            tls_config: {
              ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
              insecure_skip_verify: true,
            },
          },
          {
            bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token',
            job_name: 'kubernetes-nodes-cadvisor',
            kubernetes_sd_configs: [
              {
                role: 'node',
              },
            ],
            relabel_configs: [
              {
                action: 'labelmap',
                regex: '__meta_kubernetes_node_label_(.+)',
              },
              {
                replacement: 'kubernetes.default.svc:443',
                target_label: '__address__',
              },
              {
                regex: '(.+)',
                replacement: '/api/v1/nodes/$1/proxy/metrics/cadvisor',
                source_labels: [
                  '__meta_kubernetes_node_name',
                ],
                target_label: '__metrics_path__',
              },
            ],
            scheme: 'https',
            tls_config: {
              ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
              insecure_skip_verify: true,
            },
          },
          {
            job_name: 'kubernetes-service-endpoints',
            kubernetes_sd_configs: [
              {
                role: 'endpoints',
              },
            ],
            relabel_configs: [
              {
                action: 'keep',
                regex: true,
                source_labels: [
                  '__meta_kubernetes_service_annotation_prometheus_io_scrape',
                ],
              },
              {
                action: 'replace',
                regex: '(https?)',
                source_labels: [
                  '__meta_kubernetes_service_annotation_prometheus_io_scheme',
                ],
                target_label: '__scheme__',
              },
              {
                action: 'replace',
                regex: '(.+)',
                source_labels: [
                  '__meta_kubernetes_service_annotation_prometheus_io_path',
                ],
                target_label: '__metrics_path__',
              },
              {
                action: 'replace',
                regex: '([^:]+)(?::\\d+)?;(\\d+)',
                replacement: '$1:$2',
                source_labels: [
                  '__address__',
                  '__meta_kubernetes_service_annotation_prometheus_io_port',
                ],
                target_label: '__address__',
              },
              {
                action: 'labelmap',
                regex: '__meta_kubernetes_service_label_(.+)',
              },
              {
                action: 'replace',
                source_labels: [
                  '__meta_kubernetes_namespace',
                ],
                target_label: 'kubernetes_namespace',
              },
              {
                action: 'replace',
                source_labels: [
                  '__meta_kubernetes_service_name',
                ],
                target_label: 'kubernetes_name',
              },
              {
                action: 'replace',
                source_labels: [
                  '__meta_kubernetes_pod_node_name',
                ],
                target_label: 'kubernetes_node',
              },
            ],
          },
          {
            honor_labels: true,
            job_name: 'prometheus-pushgateway',
            kubernetes_sd_configs: [
              {
                role: 'service',
              },
            ],
            relabel_configs: [
              {
                action: 'keep',
                regex: 'pushgateway',
                source_labels: [
                  '__meta_kubernetes_service_annotation_prometheus_io_probe',
                ],
              },
            ],
          },
          {
            job_name: 'kubernetes-services',
            kubernetes_sd_configs: [
              {
                role: 'service',
              },
            ],
            metrics_path: '/probe',
            params: {
              module: [
                'http_2xx',
              ],
            },
            relabel_configs: [
              {
                action: 'keep',
                regex: true,
                source_labels: [
                  '__meta_kubernetes_service_annotation_prometheus_io_probe',
                ],
              },
              {
                source_labels: [
                  '__address__',
                ],
                target_label: '__param_target',
              },
              {
                replacement: 'blackbox',
                target_label: '__address__',
              },
              {
                source_labels: [
                  '__param_target',
                ],
                target_label: 'instance',
              },
              {
                action: 'labelmap',
                regex: '__meta_kubernetes_service_label_(.+)',
              },
              {
                source_labels: [
                  '__meta_kubernetes_namespace',
                ],
                target_label: 'kubernetes_namespace',
              },
              {
                source_labels: [
                  '__meta_kubernetes_service_name',
                ],
                target_label: 'kubernetes_name',
              },
            ],
          },
          {
            job_name: 'kubernetes-pods',
            kubernetes_sd_configs: [
              {
                role: 'pod',
              },
            ],
            relabel_configs: [
              {
                action: 'keep',
                regex: true,
                source_labels: [
                  '__meta_kubernetes_pod_annotation_prometheus_io_scrape',
                ],
              },
              {
                action: 'replace',
                regex: '(.+)',
                source_labels: [
                  '__meta_kubernetes_pod_annotation_prometheus_io_path',
                ],
                target_label: '__metrics_path__',
              },
              {
                action: 'replace',
                regex: '([^:]+)(?::\\d+)?;(\\d+)',
                replacement: '$1:$2',
                source_labels: [
                  '__address__',
                  '__meta_kubernetes_pod_annotation_prometheus_io_port',
                ],
                target_label: '__address__',
              },
              {
                action: 'labelmap',
                regex: '__meta_kubernetes_pod_label_(.+)',
              },
              {
                action: 'replace',
                source_labels: [
                  '__meta_kubernetes_namespace',
                ],
                target_label: 'kubernetes_namespace',
              },
              {
                action: 'replace',
                source_labels: [
                  '__meta_kubernetes_pod_name',
                ],
                target_label: 'kubernetes_pod_name',
              },
            ],
          },
        ],
      },
      rules: {},
    },
    serviceAccounts: {
      alertmanager: {
        create: true,
        name: null,
      },
      kubeStateMetrics: {
        create: true,
        name: null,
      },
      nodeExporter: {
        create: true,
        name: null,
      },
      pushgateway: {
        create: true,
        name: null,
      },
      server: {
        create: true,
        name: null,
      },
    },
  },
  rateLimit: {
    deployment: {
      dynamodb: {
        batchSize: 100,
        consistentReads: true,
        region: 'us-east-2',
        tableName: 'rate-limits',
      },
      glooAddress: 'gloo:9977',
      image: {
        pullPolicy: 'IfNotPresent',
        repository: 'rate-limit-ee',
        tag: '1.0.0-rc5',
      },
      redisUrl: 'redis:6379',
    },
    enabled: true,
    service: {
      name: 'rate-limit',
      port: 18081,
    },
  },
  rbac: {
    create: false,
  },
  redis: {
    deployment: {
      image: {
        pullPolicy: 'IfNotPresent',
        registry: 'docker.io',
        repository: 'redis',
        tag: '5',
      },
      staticPort: 6379,
    },
    service: {
      name: 'redis',
      port: 6379,
    },
  },

  
function(config) { values(config) }

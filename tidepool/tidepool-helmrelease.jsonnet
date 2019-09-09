local defaultHost(env) = (
  if env.gateway.default.protocol == "http"
  then env.gateway.http.dnsNames[0]
  else env.gateway.https.dnsNames[0]
);

local tidepool(config, namespace) = {
  local env = config.environments[namespace],
  local tag = "glob:%s-*" % env.gitops.branch,

  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "flux.weave.works/automated": "true",
      "flux.weave.works/tag.auth": tag,
      "flux.weave.works/tag.blip": tag,
      "flux.weave.works/tag.blob": tag,
      "flux.weave.works/tag.data": tag,
      "flux.weave.works/tag.export": tag,
      "flux.weave.works/tag.gatekeeper": tag,
      "flux.weave.works/tag.highwater": tag,
      "flux.weave.works/tag.hydrophone": tag,
      "flux.weave.works/tag.image": tag,
      "flux.weave.works/tag.jellyfish": tag,
      "flux.weave.works/tag.messageapi": tag,
      "flux.weave.works/tag.migrations": tag,
      "flux.weave.works/tag.notification": tag,
      "flux.weave.works/tag.seagull": tag,
      "flux.weave.works/tag.shoreline": tag,
      "flux.weave.works/tag.task": tag,
      "flux.weave.works/tag.tidewhisperer": tag,
      "flux.weave.works/tag.tools": tag,
      "flux.weave.works/tag.user": tag
    },
    name: "tidepool",
    namespace: namespace
  },
  spec: {
    chart: {
      git: "git@github.com:tidepool-org/development",
      path: "charts/tidepool/0.1.7",
      ref: "k8s"
    },
    releaseName: "%s-tidepool" % namespace,
    values: {
      auth: {
        deployment: {
          image: "tidepool/platform-auth:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      blip: {
        deployment: {
          image: "tidepool/blip:release-1.23.0-264f7ad48eb7d8099b00dce07fa8576f7068d0a0"
        }
      },
      blob: {
        deployment: {
          env: {
            store: {
              "s3": {
                "bucket": "tidepool-%s-%s-data" % [ config.cluster.metadata.name, namespace ]
              }
            },
            type: "s3"
          },
          image: "tidepool/platform-blob:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      data: {
        deployment: {
          image: "tidepool/platform-data:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      export: {
        deployment: {
          image: "tidepool/export:develop-ddc5f311a4bdc2adae1b423f13e047ff1828d65c"
        }
      },
      gatekeeper: {
        deployment: {
          image: "tidepool/gatekeeper:develop-6a0e3e6d83552ce378b21d76354973dcb95c9fa1"
        }
      },
      global: {
        gateway: {
          default: {
            host: defaultHost(env),
            protocol: env.gateway.default.protocol,
          }
        },
        store: {
          type: "s3"
        }
      },
      gloo: {
        enabled: false
      },
      highwater: {
        deployment: {
          image: "tidepool/highwater:develop-cb0ef1425b29f0a37c10e975876804f3ccfb1348"
        }
      },
      hydrophone: {
        deployment: {
          env: {
            store: {
              s3: {
                "bucket": "tidepool-%s-%s-asset" % [ config.cluster.metadata.name, namespace ]
              }
            },
            type: "s3"
          },
          image: "tidepool/hydrophone:develop-0683c6ba2c75ffd21ac01cd577acfeaf5cd0ef8f"
        }
      },
      image: {
        deployment: {
          env: {
            store: {
              s3: {
                bucket: "tidepool-%s-%s-data" % [ config.cluster.metadata.name, namespace ]
              }
            },
            type: "s3"
          },
          image: "tidepool/platform-image:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      ingress: {
        certificate: {
          issuer: "letsencrypt-staging",
          secretName: "tls-secret"
        },
        deployment: {
          name: "gatewayProxyV2",
          namespace: "gloo-system"
        },
        gateway: {
          http: {
            dnsNames: env.gateway.http.dnsNames
          },
          https: {
            dnsNames: env.gateway.https.dnsNames
          }
        },
        service: {
          http: {
            enabled: env.gateway.http.enabled
          },
          https: {
            enabled: env.gateway.https.enabled
          }
        }
      },
      jellyfish: {
        deployment: {
          env: {
            store: {
              s3: {
                "bucket": "tidepool-%s-%s-data" % [ config.cluster.metadata.name, namespace ]
              }
            },
            type: "s3"
          },
          image: "tidepool/jellyfish:mongo-database-a8b117f07c277dfae78a6b5f270f84cd661b3b8d"
        }
      },
      messageapi: {
        deployment: {
          image: "tidepool/message-api:develop-48e4e55d3119bd94c25fa7f01be79be85a860528"
        }
      },
      migrations: {
        deployment: {
          image: "tidepool/platform-migrations:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      mongodb: {
        enabled: false
      },
      nosqlclient: {
        enabled: env.nosqclient.enabled
      },
      notification: {
        deployment: {
          image: "tidepool/platform-notification:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      seagull: {
        deployment: {
          image: "tidepool/seagull:develop-f5b583382cc468657710b15836eafad778817f7c"
        }
      },
      shoreline: {
        deployment: {
          image: "tidepool/shoreline:develop-51f927083ba5bad0271add644728e02902d3b785"
        }
      },
      task: {
        deployment: {
          image: "tidepool/platform-task:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      tidepool: {
        namespace: {
          create: false
        }
      },
      tidewhisperer: {
        deployment: {
          image: "tidepool/tide-whisperer:develop-3d9d8e6b3417c70679ec43420f2a5e4a69cf9098"
        }
      },
      tools: {
        deployment: {
          image: "tidepool/platform-tools:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      },
      user: {
        deployment: {
          image: "tidepool/platform-user:develop-cebea363931570d3930848a21e6a3d07a54f4425"
        }
      }
    }
  }
};

function(config, namespace) tidepool(config, namespace)

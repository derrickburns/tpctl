local defaultHost(env) = (
  if env.gateway.default.protocol == "http"
  then env.gateway.http.dnsNames[0]
  else env.gateway.https.dnsNames[0]
);

local get(x, path, sep='.') = (
  local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
  std.foldl(foldFunc, std.split(path, sep), x)
);

local getElse(x, path, default) = (
  local found = get(x,path);
  if found == null then default else found
);

local dataBucket(config, namespace) = "tidepool-%s-%s-data" % [ config.cluster.metadata.name, namespace ];
local assetBucket(config, namespace) = "tidepool-%s-%s-asset" % [ config.cluster.metadata.name, namespace ];

local prefixAnnotations(prefix, repos) = {
  ["%s.fluxcd.io/%s" % [prefix, repo] ]: "%s.deployment.image" % repo
  for repo in repos
};

local filterAnnotations(env, repos) = {
  local default = getElse(env, "gitops.default", "glob:develop-*"),
  ["fluxcd.io/tag.%s" % repo ]: getElse(env, "gitops.%s" % repo, default) for repo in repos
};

local tidepool(config, prev, namespace) = {
  local env = config.environments[namespace].tidepool,

  local repos = [ "auth", "blip", "blob", "data", "export", "gatekeeper",
     "highwater", "hydrophone", "image", "jellyfish", 
     "messageapi", "migrations", "notification", "seagull", "shoreline",
     "task", "tidewhisperer", "tools", "user" ],

  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "true"
    } + filterAnnotations(env, repos)
      + prefixAnnotations("repository", repos),
    name: "tidepool",
    namespace: namespace
  },
  spec: {
    local tp = config.environments[namespace].tidepool,
    chart: {
      git: "git@github.com:tidepool-org/development",
      path: getElse(tp, "chart.path", "charts/tidepool/0.1.7"),
      ref: getElse(tp, "chart.ref", "develop"),
    },
    releaseName: "%s-tidepool" % namespace,
    values: {
      auth: {
        deployment: {
          image: getElse(prev, 'spec.values.auth.deployment.image', "tidepool/platform-auth:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      blip: {
        deployment: {
          image: getElse(prev, 'spec.values.blip.deployment.image', "tidepool/blip:release-1.23.0-264f7ad48eb7d8099b00dce07fa8576f7068d0a0")
        }
      },
      blob: {
        serviceAccount: {
          name: "blob",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          env: {
            store: {
              "s3": {
		"bucket": getElse(tp, 'buckets.data', dataBucket(config, namespace))
              }
            },
            type: "s3"
          },
          image: getElse(prev, 'spec.values.blob.deployment.image', "tidepool/platform-blob:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      data: {
        deployment: {
          image: getElse(prev, 'spec.values.data.deployment.image', "tidepool/platform-data:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      export: {
        deployment: {
          image: getElse(prev, 'spec.values.export.deployment.image', "tidepool/export:develop-ddc5f311a4bdc2adae1b423f13e047ff1828d65c")
        }
      },
      gatekeeper: {
        deployment: {
          image: getElse(prev, 'spec.values.gatekeeper.deployment.image', "tidepool/gatekeeper:develop-6a0e3e6d83552ce378b21d76354973dcb95c9fa1")
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
          image: getElse(prev, 'spec.values.highwater.deployment.image', "tidepool/highwater:develop-cb0ef1425b29f0a37c10e975876804f3ccfb1348")
        }
      },
      hydrophone: {
        serviceAccount: {
          name: "hydrophone",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          env: {
            store: {
              s3: {
		"bucket": getElse(tp, 'buckets.asset', assetBucket(config, namespace))
              }
            },
            type: "s3"
          },
          image: getElse(prev, 'spec.values.hydrophone.deployment.image', "tidepool/hydrophone:develop-0683c6ba2c75ffd21ac01cd577acfeaf5cd0ef8f")
        }
      },
      image: {
        serviceAccount: {
          name: "image",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          env: {
            store: {
              s3: {
		"bucket": getElse(tp, 'buckets.data', dataBucket(config, namespace))
              }
            },
            type: "s3"
          },
          image: getElse(prev, 'spec.values.image.deployment.image', "tidepool/platform-image:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      ingress: {
        certificate: {
	  secretName: env.certificate.secret
        },
        deployment: {
          name: "gateway-proxy-v2",
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
        serviceAccount: {
          name: "jellyfish",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          env: {
            store: {
              s3: {
		"bucket": getElse(tp, 'buckets.data', dataBucket(config, namespace))
              }
            },
            type: "s3"
          },
          image: getElse(prev, 'spec.values.jellyfish.deployment.image', "tidepool/jellyfish:mongo-database-a8b117f07c277dfae78a6b5f270f84cd661b3b8d")
        }
      },
      messageapi: {
        deployment: {
          image: getElse(prev, 'spec.values.messageapi.deployment.image', "tidepool/message-api:develop-48e4e55d3119bd94c25fa7f01be79be85a860528")
        }
      },
      migrations: {
        deployment: {
          image: getElse(prev, 'spec.values.migrations.deployment.image', "tidepool/platform-migrations:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      mongodb: {
        enabled: env.mongodb.enabled
      },
      nosqlclient: {
        enabled: env.nosqlclient.enabled
      },
      notification: {
        deployment: {
          image: getElse(prev, 'spec.values.notification.deployment.image', "tidepool/platform-notification:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      seagull: {
        deployment: {
          image: getElse(prev, 'spec.values.seagull.deployment.image', "tidepool/seagull:develop-f5b583382cc468657710b15836eafad778817f7c")
        }
      },
      shoreline: {
        deployment: {
          image: getElse(prev, 'spec.values.shoreline.deployment.image', "tidepool/shoreline:develop-51f927083ba5bad0271add644728e02902d3b785")
        }
      },
      task: {
        deployment: {
          image: getElse(prev, 'spec.values.task.deployment.image', "tidepool/platform-task:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      tidepool: {
        namespace: {
          create: false
        }
      },
      tidewhisperer: {
        deployment: {
          image: getElse(prev, 'spec.values.tidewhisperer.deployment.image', "tidepool/tide-whisperer:develop-3d9d8e6b3417c70679ec43420f2a5e4a69cf9098")
        }
      },
      tools: {
        deployment: {
          image: getElse(prev, 'spec.values.tools.deployment.image', "tidepool/platform-tools:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      user: {
        deployment: {
          image: getElse(prev, 'spec.values.user.deployment.image', "tidepool/platform-user:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      }
    }
  }
};

function(config, prev, namespace) tidepool(config, prev, namespace)

local defaultHost(env) = (
  if env.ingress.gateway.default.protocol == "http"
  then env.ingress.gateway.http.dnsNames[0]
  else env.ingress.gateway.https.dnsNames[0]
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

local prefixAnnotations(prefix, svcs) = {
  ["%s.fluxcd.io/%s" % [prefix, svc] ]: "%s.deployment.image" % svc
  for svc in svcs
};

local filterAnnotations(env, svcs) = {
  local default = getElse(env, "gitops.default", "glob:develop-*"),
  ["fluxcd.io/tag.%s" % svc ]: getElse(env, "gitops.%s" % svc, default) for svc in svcs
};

local tidepool(config, prev, namespace) = {
  local env = config.environments[namespace].tidepool,

  local svcs = [ "auth", "blip", "blob", "data", "export", "gatekeeper",
     "highwater", "hydrophone", "image", "jellyfish", 
     "messageapi", "migrations", "notification", "seagull", "shoreline",
     "task", "tidewhisperer", "tools", "user" ],

  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "true"
    } + filterAnnotations(env, svcs)
      + prefixAnnotations("repository", svcs),
    name: "tidepool",
    namespace: namespace
  },
  local tp = config.environments[namespace].tidepool,
  local resources = {
    requests: {
      memory: getElse( tp, 'resources.requests.memory', "64Mi"),
      cpu: getElse( tp, 'resources.requests.cpu', "50m"), 
    },
    limits: {
      memory: getElse( tp, 'resources.limits.memory', "128Mi"),
      cpu: getElse( tp, 'resources.limits.cpu', "100m"),
	    }
  }, 
  spec: {
     rollback: {
       enable: true,
       force: true,
    },
    chart: {
      git: "git@github.com:tidepool-org/development",
      path: getElse(tp, "chart.path", "charts/tidepool/0.1.7"),
      ref: getElse(tp, "chart.ref", "develop"),
    },
    releaseName: "%s-tidepool" % namespace,
    local podAnnotations = {
       "config.linkerd.io/proxy-cpu-request": "0.2",
       "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
    },
    local replicas = getElse(tp, 'deployment.replicas', 1),
    values: {
      auth: {
        podAnnotations: podAnnotations,
        resources: resources,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.auth.deployment.image', "tidepool/platform-auth:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      blip: {
        resources: resources,
        podAnnotations: podAnnotations,

        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.blip.deployment.image', "tidepool/blip:release-1.23.0-264f7ad48eb7d8099b00dce07fa8576f7068d0a0")
        }
      },
      blob: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        serviceAccount: {
          name: "blob",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          replicas: replicas,
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
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.data.deployment.image', "tidepool/platform-data:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      export: {
        resources : {
          requests: {
            memory: "256Mi",
            cpu: "500m",
          },
          limits: {
            memory: "256Mi",
            cpu: "1000m",
	  }
        }, 
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.export.deployment.image', "tidepool/export:develop-ddc5f311a4bdc2adae1b423f13e047ff1828d65c")
        }
      },
      gatekeeper: {
        resources : {
          requests: {
            memory: "64Mi",
            cpu: "500m",
          },
          limits: {
            memory: "128Mi",
            cpu: "1000m",
	  }
        }, 
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.gatekeeper.deployment.image', "tidepool/gatekeeper:develop-6a0e3e6d83552ce378b21d76354973dcb95c9fa1")
        }
      },
      global: {
        gateway: {
          default: {
            host: defaultHost(env),
            protocol: env.ingress.gateway.default.protocol,
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
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.highwater.deployment.image', "tidepool/highwater:develop-cb0ef1425b29f0a37c10e975876804f3ccfb1348")
        }
      },
      hydrophone: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        serviceAccount: {
          name: "hydrophone",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          replicas: replicas,
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
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        serviceAccount: {
          name: "image",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          replicas: replicas,
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
        certificate: env.certificate,
        deployment: {
          replicas: replicas,
          name: "gateway-proxy-v2",
          namespace: "gloo-system"
        },
        gateway: env.ingress.gateway,
        service: env.ingress.service,
      },
      jellyfish: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        serviceAccount: {
          name: "jellyfish",
        },
        securityContext: {
          fsGroup: 65534 // To be able to read Kubernetes and AWS token files
        },
        deployment: {
          replicas: replicas,
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
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.messageapi.deployment.image', "tidepool/message-api:develop-48e4e55d3119bd94c25fa7f01be79be85a860528")
        }
      },
      migrations: {
        resources : {
          requests: {
            memory: "256Mi",
            cpu: "500m",
          },
          limits: {
            memory: "256Mi",
            cpu: "1000m",
	  }
        }, 
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
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
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.notification.deployment.image', "tidepool/platform-notification:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      seagull: {
        resources : {
          requests: {
            memory: "256Mi",
            cpu: "500m",
          },
          limits: {
            memory: "256Mi",
            cpu: "1000m",
	  }
        }, 
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.seagull.deployment.image', "tidepool/seagull:develop-f5b583382cc468657710b15836eafad778817f7c")
        }
      },
      shoreline: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.shoreline.deployment.image', "tidepool/shoreline:develop-51f927083ba5bad0271add644728e02902d3b785")
        }
      },
      task: {
        resources: resources,
        podAnnotations: podAnnotations,

        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.task.deployment.image', "tidepool/platform-task:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      tidepool: {
        namespace: {
          create: false
        }
      },
      tidewhisperer: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.tidewhisperer.deployment.image', "tidepool/tide-whisperer:develop-3d9d8e6b3417c70679ec43420f2a5e4a69cf9098")
        }
      },
      tools: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.tools.deployment.image', "tidepool/platform-tools:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      },
      user: {
        resources: resources,
        podAnnotations: podAnnotations,
        hpa: {
          enabled: getElse(tp, 'hpa.enabled', false),
        },
        deployment: {
          replicas: replicas,
          image: getElse(prev, 'spec.values.user.deployment.image', "tidepool/platform-user:develop-cebea363931570d3930848a21e6a3d07a54f4425")
        }
      }
    }
  }
};

function(config, prev, namespace) tidepool(config, prev, namespace)

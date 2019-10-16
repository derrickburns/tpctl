local get(x, path, sep='.') = (
  local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
  std.foldl(foldFunc, std.split(path, sep), x)
);

local getElse(x, path, default) = (
  local found = get(x, path);
  if found == null then default else found
);

local deployment(config) = {
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: "external-secrets",
    namespace: "external-secrets"
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        "app.kubernetes.io/instance": "external-secrets",
        "app.kubernetes.io/name": "kubernetes-external-secrets"
      }
    },
    template: {
      metadata: {
        labels: {
          "app.kubernetes.io/instance": "external-secrets",
          "app.kubernetes.io/name": "kubernetes-external-secrets"
        }
      },
      spec: {
        securityContext: {
          fsGroup: 65534
        },
        containers: [
          {
            env: [
              {
                name: "AWS_REGION",
                value: config.cluster.metadata.region,
              },
              {
                name: "LOG_LEVEL",
                value: config.logLevel,
              },
              {
                name: "METRICS_PORT",
                value: "3001"
              },
              {
                name: "POLLER_INTERVAL_MILLISECONDS",
                value: getElse(config.pkgs["external-secrets"], 'poller_interval', '120000'),
              }
            ],
            image: "tidepool/external-secrets:iam2",
            imagePullPolicy: "IfNotPresent",
            name: "kubernetes-external-secrets",
          }
        ],
        "serviceAccountName": "external-secrets"
      }
    }
  }
};

function(config) deployment(config)



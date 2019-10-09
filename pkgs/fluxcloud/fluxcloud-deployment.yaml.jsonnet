local get(x, path, sep='.') = (
  local foldFunc(x, key) = if std.isObject(x) && std.objectHasAll(x, key) then x[key] else null;
  std.foldl(foldFunc, std.split(path, sep), x)
);

local getElse(x, path, default) = (
  local found = get(x, path);
  if found == null then default else found
);

local Deployment(config) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: "fluxcloud",
    namespace: "flux",
    annotations: {
      "secret.reloader.stakater.com/reload": "slack"
    },
  },
  spec: {
    selector: {
      matchLabels: {
        name: "fluxcloud",
      },
    },
    replicas: 1,
    strategy: {},
    template: {
      metadata: {
        labels: {
            name: "fluxcloud",
        },
      },
      spec: {
        containers: [
          {
            name: 'fluxcloud',
            image: 'justinbarrick/fluxcloud:v0.3.8',
            ports: [
              {
                containerPort: 3032,
              },
            ],
            env: [
              {
                name: 'SLACK_URL',
                valueFrom: {
                  secretKeyRef: {
                    name: config.pkgs.fluxcloud.secret,
                    key: 'url',
                  },
                },
              },
              {
                name: 'SLACK_CHANNEL',
                value: getElse(config, 'pkgs.fluxcloud.channel', '#flux-%s' % config.cluster.metadata.name),
              },
              {
                name: 'SLACK_USERNAME',
                value: getElse(config, 'pkgs.fluxcloud.username', 'derrickburns'),
              },
              {
                name: 'SLACK_ICON_EMOJI',
                value: ':heart:',
              },
              {
                name: 'GITHUB_URL',
                value: config.github.https,
              },
              {
                name: 'LISTEN_ADDRESS',
                value: ':3032',
              },
            ],
          },
        ],
      },
    },
  },
};

function(config) Deployment(config)

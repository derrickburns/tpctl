local lib = import '../../lib/lib.jsonnet';

local Deployment(config, namespace) = {
  local me = config.namespaces[namespace].fluxcloud,
  local secretName = lib.getElse(me, 'secret', 'slack'),
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: 'fluxcloud',
    namespace: namespace,
    annotations: {
      'secret.reloader.stakater.com/reload': secretName,
    },
  },
  spec: {
    selector: {
      matchLabels: {
        name: 'fluxcloud',
      },
    },
    replicas: 1,
    strategy: {},
    template: {
      metadata: {
        labels: {
          name: 'fluxcloud',
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
                    name: secretName,
                    key: 'url',
                  },
                },
              },
              {
                name: 'SLACK_CHANNEL',
                value: lib.getElse(me, 'channel', '#flux-%s' % config.cluster.metadata.name),
              },
              {
                name: 'SLACK_USERNAME',
                value: lib.getElse(me, 'username', 'derrickburns'),
              },
              {
                name: 'SLACK_ICON_EMOJI',
                value: ':heart:',
              },
              {
                name: 'GITHUB_URL',
                value: config.general.github.https,
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

function(config, prev, namespace) Deployment(config, namespace)

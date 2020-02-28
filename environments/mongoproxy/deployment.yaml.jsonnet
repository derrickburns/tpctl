local lib = import '../../lib/lib.jsonnet';

local deployment(config, namespace) =
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      annotations: {
        'fluxcd.io/automated': "true",
        'fluxcd.io/tag.mongoproxy': "glob:master-*",
      },
      name: 'mongoproxy',
      namespace: namespace,
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          name: 'mongoproxy',
        },
      },
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          labels: {
            name: 'mongoproxy',
          },
        },
        spec: {
          containers: [
            {
              name: 'mongoproxy',
              image: 'tidepool/mongoproxy:latest',
              imagePullPolicy: 'IfNotPresent',
              ports: [{
                containerPort: 27017,
              }],
              envFrom: [
               { 
                 secretRef: {
                   name: mongoproxy
                 }
               }
              ],
              env: [
                {
                  name: 'PORT',
                  value: '27017',
                },
              ],
            },
          ],
          restartPolicy: 'Always',
        },
      },
    },
  };

function(config, prev, namespace) deployment(config, namespace)

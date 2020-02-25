local lib = import '../../lib/lib.jsonnet';

local deployment(config, namespace) =
  {
    apiVersion: 'extensions/v1beta1',
    kind: 'Deployment',
    metadata: {
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
            },
          ],
          restartPolicy: 'Always',
        },
      },
    },
  };

function(config, prev, namespace) deployment(config, namespace)

local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local workflowTemplate(me) = k8s.k('argoproj.io/v1alpha1', 'WorkflowTemplate') + k8s.metadata('generate-accounts', me.namespace) {
  local entry = 'generate-accounts',
  spec: {
    serviceAccountName: 'account-tool',
    entrypoint: entry,
    imagePullSecrets: [
      {
        name: 'docker-hub',
      },
    ],
    arguments: {
      parameters: [
        {
          name: 'env',
          value: 'dev1',
        },
        {
          name: 'accountName',
          value: 'loadtest',
        },
      ],
    },
    affinity: {
      nodeAffinity: k8s.nodeAffinity(),
    },
    tolerations: [k8s.toleration()],
    volumes: [
      {
        name: '%s' % me.pkg,
        emptyDir: {},
      },
    ],
    templates: [
      {
        name: 'generate-accounts',
        inputs: {
          parameters: [
            {
              name: 'env',
            },
            {
              name: 'accountName',
            },
          ],
        },
        container: {
          name: 's3-upload',
          image: 'amazon/aws-cli:2.0.24',
          command: [
            'aws',
            's3',
            'cp',
          ],
          args: [
            '/opt/accounts/Account-Credentials.csv',
            's3://tidepool-account-tool/{{inputs.parameters.env}}-credentials.csv',
          ],
          volumeMounts: [
            {
              mountPath: '/opt/accounts',
              name: me.pkg,
            },
          ],
        },
        initContainers: [
          {
            name: 'generate-accounts',
            image: 'tidepool/account-tool:v0.1.0',
            command: [
              '/bin/bash',
              '-c',
            ],
            args: [
              'cd /opt/accounts && /app/accountTool.py create --env {{inputs.parameters.env}} --master {{inputs.parameters.accountName}}_{{inputs.parameters.env}}-MASTER@tidepool.org',
            ],
            tty: true,
            volumeMounts: [
              {
                mountPath: '/opt/accounts',
                name: me.pkg,
              },
            ],
          },
        ],
      },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [workflowTemplate(me)]
)

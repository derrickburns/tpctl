local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local generateAccounts(me, account) = k8s.k('batch/v1', 'Job') + k8s.metadata('generate-accounts-%s' % account.env, me.namespace) {
  spec+: {
    backoffLimit: 0,
    template: {
      spec: {
        affinity: {
          nodeAffinity: k8s.nodeAffinity(),
        },
        tolerations: [k8s.toleration()],
        restartPolicy: 'Never',
        containers+: [
          {
            name: 's3-upload',
            image: 'amazon/aws-cli:2.0.24',
            command: [
              'aws',
              's3',
              'cp',
            ],
            args: [
              '/opt/accounts/Account-Credentials.csv',
              's3://tidepool-account-tool/%s-credentials.csv' % account.env,
            ],
            volumeMounts: [
              {
                mountPath: '/opt/accounts',
                name: me.pkg,
              },
            ],
          },
        ],
        initContainers+: [
          {
            name: 'generate-accounts',
            image: 'tidepool/account-tool:v0.1.0',
            command: [
              '/bin/bash',
              '-c',
            ],
            args: [
              'cd /opt/accounts && /app/accountTool.py create --env %s --master %s-MASTER@tidepool.org' % [account.env, account.masterAccount],
            ],
            volumeMounts: [
              {
                mountPath: '/opt/accounts',
                name: me.pkg,
              },
            ],
          },
        ],
        serviceAccountName: 'account-tool',
        imagePullSecrets: [
          { name: 'docker-hub' },
        ],
        volumes: [
          {
            name: me.pkg,
            emptyDir: {},
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [generateAccounts(me, account) for account in me.accounts if account.generate == true]
)

local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local generateAccounts(me) = k8s.k('batch/v1', 'Job') + k8s.metadata('generate-accounts', me.namespace) {
  spec+: {
    template: {
      spec: {
        affinity: {
          nodeAffinity: k8s.nodeAffinity(),
        },
        tolerations: [k8s.toleration()],
        restartPolicy: 'Never',
        containers+: [
          {
            image: 'amazon/aws-cli:2.0.24 ',
            command: [
              's3',
              'cp',
              '/opt/account-tool/Account-Credentials.csv',
              's3://tidepool-account-tool/%s-credentials.csv' me.env,
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
            image: 'tidepool/account-tool:v0.1.0',
            command: [
              '/bin/bash',
              '-c',
              '"cd /opt/accounts && /app/accountTool.py create --env %s --master %s-MASTER@tidepool.org"' % me.env % me.masterAccount,
            ],
            volumeMounts: [
              {
                mountPath: '/opt/accounts',
                name: me.pkg,
              },
            ],
          },
        ],
        serviceAccountName: account-tool
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

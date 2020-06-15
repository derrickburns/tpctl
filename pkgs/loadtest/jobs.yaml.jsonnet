local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local affinity = {
  nodeAffinity: {
    requiredDuringSchedulingIgnoredDuringExecution: {
      nodeSelectorTerms: [{
        matchExpressions: [
          {
            key: 'role',
            operator: 'In',
            values: ['monitoring'],
          },
        ],
      }],
    },
  },
};

local tolerations = [
  {
    key: 'role',
    operator: 'Equal',
    value: 'monitoring',
    effect: 'NoSchedule',
  },
];

local persistentVolumeClaim(me) = k8s.pvc(me, '200Mi', 'monitoring-expanding');

local generateAccounts(me) = k8s.k('batch/v1', 'Job') + k8s.metadata('generate-accounts', me.namespace) {
  spec+: {
    template: {
      affinity: affinity,
      tolerations: tolerations,
      containers+: {
        image: 'tidepool/account-tool:latest',
        command: [
          '/bin/bash',
          '-c',
          'echo',
          'tidepool',
          '|',
          '/app/accountTool.py',
          'python3',
          'accountTool.py',
          'create',
          '--numAccounts',
          lib.getElse(me, 'accounts', 50,),
          '--studyID',
          me.studyID,
          '--master',
          '%s-MASTER@tidepool.org' % me.studyID,
          '--env',
          me.env,
        ],
        volumeMounts: [
          {
            mountPath: '/opt/k6',
            name: me,
          },
        ],
      },
      volumes: [
        {
          name: me,
          persistentVolumeClaim: {
            claimName: me,
          },
        },
      ],
    },
  },
};

local cronJob(me, job) = k8s.k('batch/v1beta1', 'CronJob') + k8s.metadata('loadtest', me.namespace) {
  spec+: {
    schedule: job.schedule,
    template: {
      affinity: affinity,
      tolerations: tolerations,
      containers+: {
        image: 'tidepool/loadtest:latest',
        env: if global.isEnabled(me.config, 'statsd-exporter') then [
          k8s.envVar('K6_STATSD_ADDR', 'statsd-exporter:9125'),
        ] else [],
        command: [
          'k6',
          'run',
          '-e',
          'csv=/opt/k6/%s-Credentials.csv' % me.studyID,
          '-e',
          'env=dev1',
          '--out',
          'statsd',
          job.name,
        ],
        volumeMounts: [
          {
            mountPath: '/opt/k6',
            name: me,
          },
        ],
      },
      volumes: [
        {
          name: me,
          persistentVolumeClaim: {
            claimName: me,
          },
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  local defaults = [persistentVolumeClaim(me), generateAccounts(me)];
  local tests = lib.getElse(me, 'tests', null);
  if tests == null then
    defaults
  else
    [cronJob(me, test) for test in me.tests] + defaults
)

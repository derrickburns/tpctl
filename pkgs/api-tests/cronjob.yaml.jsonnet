local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local cronJob(me, test) = k8s.k('batch/v1beta1', 'CronJob') + k8s.metadata('api-tests-%s-%s' % [test.name, std.asciiLower(test.env)], me.namespace) {
  local cmd = 'npx newman run %s -e tests/%s.postman_environment.json --env-var "loginEmail=$%s_USER_EMAIL" --env-var "loginPw=$%s_USER_PASSWORD" --env-var "clinicEmail=$%s_CLINIC_EMAIL" --env-var "clinicPw=$%s_CLINIC_PASSWORD"' % [test.command, test.env, test.env, test.env, test.env, test.env],
  spec+: {
    schedule: test.schedule,
    jobTemplate: {
      spec: {
        ttlSecondsAfterFinished: 100,
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
                name: 'api-tests-%s-%s' % [test.name, std.asciiLower(test.env)],
                image: 'tidepool/api-tests:v0.3.0',
                env: [],
                command: [
                  '/bin/sh',
                  '-c',
                ],
                args: [
                  cmd,
                ],
                envFrom: [
                  {
                    secretRef: {
                      name: me.pkg,
                    },
                  },
                ],
              },
            ],
            imagePullSecrets: [
              {
                name: 'docker-hub',
              },
            ],
          },
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [cronJob(me, test) for test in me.tests if test.enabled == true]
)

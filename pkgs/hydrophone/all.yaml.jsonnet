local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tidepool = import '../../lib/tidepool.jsonnet';

local deployment(me) = lib.merge(flux.deployment(me) + {
  _containers:: {
    image: 'tidepool/hydrophone:master-latest',

    env: me.tidepool.mongo + [
      k8s.envVar('TIDEPOOL_STORE_DATABASE', 'confirm'),
      k8s.envSecret('SERVER_SECRET', 'server', 'ServiceAuth'),
      k8s.envVar('REGION', tidepool.region),
      k8s.envVar('SHORELINE_HOST', 'http://shoreline:%s' % tidepool.port.shoreline),
      k8s.envVar('SEAGULL_HOST', 'http://seagull:%s' % tidepool.port.seagull),
      k8s.envVar('GATEKEEPER_HOST', 'http://gatekeeper:%s' % tidepool.port.gatekeeper),
      k8s.envVar('HIGHWATER_HOST', 'http://highwater:%s' % tidepool.port.highwater),
      k8s.envVar('TIDEPOOL_HYDROPHONE_ENV', std.manifestJson({
        gatekeeper: {
          serviceSpec: {
            type: 'static',
            hosts: ['http://gatekeeper:%s' % tidepool.port.gatekeeper],
          },
        },
        hakken: {
          host: 'hakken',
          skipHakken: true,
        },
        highwater: {
          metricsSource: 'hydrophone',
          metricsVersion: 'v0.0.1',
          name: 'highwater',
          serviceSpec: { type: 'static', hosts: ['http://highwater:%s' % tidepool.ports.highwater] },
        },
        seagull: { serviceSpec: { type: 'static', hosts: ['http://seagull:%s' % tidepool.ports.seagull] } },
        shoreline: {
          name: 'hydrophone',
          serviceSpec: { type: 'static', hosts: ['http://shoreline:%s' % tidepool.ports.shoreline] },
          tokenRefreshInterval: '1h',
        },
      })),
      k8s.envVar('PROTOCOL', tidepool.gateway.default.protocol),
      k8s.envVar('TIDEPOOL_HYDROPHONE_SERVICE', std.manifestJson(
        {
          hydrophone: {
            assetUrl: tidepool.hydrophone.s3.url(),
            webUrl: tidepool.host.app(),
          },
          mongo: {
            connectionString: '',
          },
          service: {
            host: 'localhost:%s' % tidepool.hydrophone.port,
            protocol: 'http',
            service: 'hydrophone',
          },
          sesEmail: {
            fromAddress: me.deployment.env.fromAddress,
          },
        }
      )),
    ],
    ports: [{
      containerPort: tidepool.ports.hydrophone,
    }],
    livenessProbe: {
      httpGet: {
        path: '/status',
        port: tidepool.ports.hydrophone,
      },
      initialDelaySeconds: 3,
      periodSeconds: 10,
    },
  },
  spec+: {
    template+: {
      spec+: {
        initContainers: [tidepool.shoreline_init_container],
      },
    },
  },
}, me.deployment.values);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(tidepool.ports.hydrophone, tidepool.ports.hydrophone)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)

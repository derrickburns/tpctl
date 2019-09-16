local mongoSecret(namespace) = {
  apiVersion: "v1",
  data: {
    Scheme: std.base64( "mongodb ),
    Addresses: std.base64( "mongodb" ),
    Username: "",
    Password: "",
    Database: "",
    Tls: std.base( "false" ),
    OptParams: "",
  },
  kind: "Secret",
  metadata: {
    name: "mongo",
    namespace:  namespace,
  },
  type: "Opaque",
};

function(config, namespace) mongoSecret(namespace)

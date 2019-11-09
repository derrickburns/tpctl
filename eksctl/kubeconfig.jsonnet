local kubeconfig(config, prev) = prev {
  contexts: [ { 
      context: {
        cluster: prev.contexts[0].context.cluster,
        user: "tidepool" + "." + prev.contexts[0].context.cluster,
      },
      name: config.cluster.metadata.name + '.' + config.cluster.metadata.region
  } ],
  "current-context": config.cluster.metadata.name + '.' + config.cluster.metadata.region,
  users: [ {
     name: "tidepool" + "." + prev.contexts[0].context.cluster,
     user: prev.users[0].user
  } ]
};

function(config, prev) kubeconfig(config, prev)

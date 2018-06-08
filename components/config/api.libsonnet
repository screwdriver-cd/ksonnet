{
  api:: {
    withAuth(privateKey, publicKey, cookiePassword, encryptionPassword):: self + {
      auth: {
        jwtPublicKey: publicKey,
        jwtPrivateKey: privateKey,
        cookiePassword: cookiePassword,
        encryptionPassword: encryptionPassword,
        https: true,
      },
    },

    withHttpd(uri, host="0.0.0.0", port=80):: self + {
      httpd: {
        port: port,
        host: host,
        uri: uri,
        tls: false,
      },
    },

    withDatastore(datastore):: self + {
      datastore: {
        plugin: datastore.name,
        [datastore.name]: datastore,
      },
    },

    withScms(scms):: self + {
      scms: scms,
    },

    withExecutor(executor):: self + {
      executor: {
        plugin: executor.name,
        [executor.name]: {
          enabled: true,
          options: executor,
        },
      },
    },

    withEcosystem(uiUrl, storeUrl):: self + {
      ecosystem: {
        ui: uiUrl,
        store: storeUrl,
      },
    },
  },

  datastores:: {
    sequelize(dialect, database, host, port, username, password):: {
      name:: "sequelize",
      dialect: dialect,
      database: database,
      host: host,
      port: port,
      username: username,
      password: password,
    }
  },

  scms:: {
    github(clientId, clientSecret, secret, privateRepo=false, name="github"):: {
      [name]: {
        plugin: "github",
        config: {
          oauthClientId: clientId,
          oauthClientSecret: clientSecret,
          secret: secret,
          privateRepo: privateRepo
        },
      },
    },
  },

  executors:: {
    k8s(namespace="default", version="stable", resources=null):: {
      name:: "k8s",
      kubernetes: {
        jobsNamespace: namespace,
        resources: resources,
      },
      launchVersion: version,
    },

    resources:: {
      cpu(low=0.5, high=4):: {
        cpu: {
          low: low,
          high: high,
        },
      },
      memory(low=2, high=6):: {
        memory: {
          low: low,
          high: high,
        },
      },
    },
  },
}

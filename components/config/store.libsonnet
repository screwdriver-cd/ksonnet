{
  store:: {
    withAuth(jwtPublicKey):: self + {
      auth: {
        jwtPublicKey: jwtPublicKey,
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

    withBuilds(expires=23328000000, bytes=1073741824):: self + {
      builds: {
        expiresInSec: expires,
        maxByteSize: bytes,
      },
    },

    withCommands(expires=23328000000, bytes=1073741824):: self + {
      commands: {
        expiresInSec: expires,
        maxByteSize: bytes,
      },
    },

    withStrategy(strategy):: self + {
      strategy: {
        plugin: strategy.name,
        [strategy.name]: strategy,
      },
    },

    withEcosystem(uiUrl, apiUrl):: self + {
      ecosystem: {
        ui: uiUrl,
        api: apiUrl,
      },
    },
  },

  strategies:: {
    s3(region, bucket):: {
      name:: "s3",
      accessKeyId: null,
      secretAccessKey: null,
      region: region,
      bucket: bucket,
    }
  },
}

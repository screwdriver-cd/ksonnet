{
  global: {},
  components: {
    shared: {
      // Namespace for services to run in
      namespace: "sd-services",
      // Service Account to use in the services namespace
      serviceAccount: "sd-manager",
      // Amazon cert for HTTPS at the Load Balancer
      acmCert: "",
      // IP restriction for the Load Balancer
      restrictedIPs: [
        "0.0.0.0/0"
      ],
      // Version of the Launcher
      launchVersion: "v4.0.101",
      // Configuration of the builds
      builds: {
        // Namespace for builds to run in
        namespace: "sd-builds",
        // Service Account to use in the builds namespace
        serviceAccount: "sd-builder",
      },
      // Domain name to use (will become api.demo.screwdriver.cd, ui.demo.screwdriver.cd)
      domain: "demo.screwdriver.cd",
      // Private key used for signing jwt tokens
      jwtPublicKey: "",
      // Public key used for verifying the signature
      jwtPrivateKey: "",
    },
    api: {
      // Number of available instances
      replicas: 2,
      // Version of the API
      version: "v0.5.356",
      // Configuration for GitHub.com integration
      github: {
        // OAuth Client ID
        client_id: "",
        // OAuth Client Secret
        client_secret: "",
        // Secret to add to GitHub webhooks so that we can validate them
        secret: "",
        // Whether it supports private repo: boolean value.
        // If true, it will ask for read and write access to public and private repos
        // https://developer.github.com/v3/oauth/#scopes
        privateRepo: false,
      },
      // Configuration for Postgres
      postgres: {
        // Database name
        database: "",
        // Host and Port for PostgreSQL server
        host: "",
        port: "",
        // Username and Password for PostgreSQL server
        username: "",
        password: "",
      },
      // Used for encrypting session data
      cookiePassword: "",
      // Used for encrypting stored secrets
      vaultPassword: "",
    },
    ui: {
      // Number of available instances
      replicas: 2,
      // Version of the UI
      version: "v1.0.270",
    },
    store: {
      // Number of available instances
      replicas: 2,
      // Version of the Store
      version: "v3.1.2",
      // Amazon S3 region
      region: "us-west-2",
      // Amazon S3 bucket that holds all the logs and artifacts
      bucket: "",
      // Amazon IAM role for the Store to interact with S3
      role: "",
    },
  },
}

local params = import "../../components/params.libsonnet";

params + {
  components +: {
    shared +: {
      // Amazon cert for HTTPS at the Load Balancer
      acmCert: "arn:aws:acm:us-west-2:1234567890:certificate/12345",
      // Public key for verifying (note the spacing)
      jwtPublicKey: "-----BEGIN PUBLIC KEY-----
INSERT REAL VALUES HERE
-----END PUBLIC KEY-----",
      // Private key for signing (note the spacing)
      jwtPrivateKey: "-----BEGIN RSA PRIVATE KEY-----
INSERT REAL VALUES HERE
-----END RSA PRIVATE KEY-----",
      // Domain name to use (will become api.demo.screwdriver.cd, ui.demo.screwdriver.cd)
      domain: "demo.screwdriver.cd",
      // IP restriction for the Load Balancer
      restrictedIPs: [
        "0.0.0.0/0",       // Everyone
        "192.30.252.0/22", // GitHub
      ],
    },
    api +: {
      github +: {
        // OAuth Client ID
        client_id: "INSERT REAL VALUES HERE",
        // OAuth Client Secret
        client_secret: "INSERT REAL VALUES HERE",
        // Secret to add to GitHub webhooks so that we can validate them
        secret: "INSERT REAL VALUES HERE",
      },
      postgres +: {
        // Database name
        database: "INSERT REAL VALUES HERE",
        // Host and Port for PostgreSQL server
        host: "12345.us-west-2.rds.amazonaws.com",
        port: "5432",
        // Username and Password for PostgreSQL server
        username: "INSERT REAL VALUES HERE",
        password: "INSERT REAL VALUES HERE",
      },
      // Used for encrypting session data
      cookiePassword: "INSERT REAL VALUES HERE",
      // Used for encrypting stored secrets
      vaultPassword: "INSERT REAL VALUES HERE",
    },
    store +: {
      // Amazon IAM role for the Store to interact with S3
      role: "arn:aws:iam::1234567890:role/screwdriver-role-12345",
      // Amazon S3 bucket that holds all the logs and artifacts
      bucket: "screwdriver-s3bucket-123456",
    },
  },
}

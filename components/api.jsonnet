local sdc = import './config/api.libsonnet';
local tier = "api";
local params = std.extVar("__ksonnet/params").components.shared
  + std.extVar("__ksonnet/params").components[tier];
local buildParams = params.builds;

local labels = {
  app: "screwdriver",
  tier: tier,
};

/* Config */
local config = sdc.api
  .withAuth(
    params.jwtPrivateKey,
    params.jwtPublicKey,
    params.cookiePassword,
    params.vaultPassword
  )
  .withHttpd("https://api." + params.domain)
  .withDatastore(sdc.datastores.sequelize(
    "postgres",
    params.postgres.database,
    params.postgres.host,
    params.postgres.port,
    params.postgres.username,
    params.postgres.password,
  ))
  .withScms(sdc.scms.github(
    params.github.client_id,
    params.github.client_secret,
    params.github.secret,
    params.github.privateRepo,
  ))
  .withExecutor(sdc.executors.k8s(
    buildParams.namespace,
    params.launchVersion,
    sdc.executors.resources.cpu() + sdc.executors.resources.memory()
  ))
  .withEcosystem(
    "https://ui." + params.domain,
    "https://store." + params.domain,
  );

/* Secret */
local secret = {
  apiVersion: 'v1',
  kind: 'Secret',
  type: 'Opaque',
  metadata: {
    name: "sd-secrets-" + tier,
    namespace: params.namespace,
  },
  data: {
    'local.yaml': std.base64(std.manifestYamlDoc(config)),
  },
};

/* Service */
local service = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: "sd-" + tier,
    namespace: params.namespace,
    annotations: {
        "service.beta.kubernetes.io/aws-load-balancer-backend-protocol": "http",
        "service.beta.kubernetes.io/aws-load-balancer-ssl-ports": "443",
        "service.beta.kubernetes.io/aws-load-balancer-ssl-cert": params.acmCert,
    },
  },
  spec: {
    ports: [
      {
        name: "http",
        port: 80,
        targetPort: 80,
      },
      {
        name: "https",
        port: 443,
        targetPort: 80,
      },
    ],
    selector: labels,
    type: 'LoadBalancer',
    loadBalancerSourceRanges: params.restrictedIPs,
  },
};

/* Deployment */
local deployment = {
  apiVersion: 'extensions/v1beta1',
  kind: 'Deployment',
  metadata: {
    labels: labels,
    name: "sd-" + tier,
    namespace: params.namespace,
  },
  spec: {
    replicas: params.replicas,
    revisionHistoryLimit: 1,
    selector: {
      matchLabels: labels,
    },
    template: {
      metadata: {
        labels: labels,
      },
      spec: {
        containers: [
          {
            image: 'screwdrivercd/screwdriver:' + params.version,
            name: 'api',
            ports: [
              {
                containerPort: 80,
              },
            ],
            volumeMounts: [
              {
                mountPath: '/config/local.yaml',
                name: 'config',
                subPath: 'local.yaml',
              },
            ],
          },
        ],
        serviceAccountName: params.serviceAccount,
        volumes: [
          {
            name: 'config',
            secret: {
              items: [
                {
                  key: 'local.yaml',
                  path: 'local.yaml',
                },
              ],
              secretName: "sd-secrets-" + tier,
            },
          },
        ],
      },
    },
  },
};

local k = import 'k.libsonnet';
k.core.v1.list.new([
  service, 
  deployment, 
  secret
])

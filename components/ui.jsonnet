local tier = 'ui';
local params = std.extVar('__ksonnet/params').components.shared
  + std.extVar('__ksonnet/params').components[tier];

local labels = {
  app: 'screwdriver',
  tier: tier,
};

/* Service */
local service = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'sd-' + tier,
    namespace: params.namespace,
    annotations: {
        'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'http',
        'service.beta.kubernetes.io/aws-load-balancer-ssl-ports': '443',
        'service.beta.kubernetes.io/aws-load-balancer-ssl-cert': params.acmCert,
    },
  },
  spec: {
    ports: [
      {
        name: 'http',
        port: 80,
        targetPort: 80,
      },
      {
        name: 'https',
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
    name: 'sd-' + tier,
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
            env: [
              {
                name: 'ECOSYSTEM_API',
                value: 'https://api.' + params.domain,
              },
              {
                name: 'ECOSYSTEM_STORE',
                value: 'https://store.' + params.domain,
              },
              {
                name: 'AVATAR_HOSTNAME',
                value: '*.githubusercontent.com',
              },
            ],
            image: 'screwdrivercd/ui:' + params.version,
            name: 'ui',
            ports: [
              {
                containerPort: 80,
              },
            ],
          },
        ],
        serviceAccountName: params.serviceAccount,
      },
    },
  },
};

local k = import 'k.libsonnet';
k.core.v1.list.new([
  service, 
  deployment
])

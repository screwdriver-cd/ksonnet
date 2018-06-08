local params = std.extVar("__ksonnet/params").components.shared;
local store = std.extVar("__ksonnet/params").components.store;

/* Namespaces */
local namespaces = [
  {
    apiVersion: "v1",
    kind: "Namespace",
    metadata: {
      name: params.namespace,
      annotations: {
        "iam.amazonaws.com/allowed-roles": '["' + store.role + '"]',
      },
    },
  },
  {
    apiVersion: "v1",
    kind: "Namespace",
    metadata: {
      name: params.builds.namespace,
    },
  }
];

/* Service Account */
local serviceAccounts = [
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: params.serviceAccount,
      namespace: params.namespace,
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: params.builds.serviceAccount,
      namespace: params.builds.namespace,
    },
  }
];

/* Role Binding so the API can deploy into the Build Namespace */
local roleBinding = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'RoleBinding',
  metadata: {
    name: params.serviceAccount,
    namespace: params.builds.namespace,
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'admin',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: params.serviceAccount,
      namespace: params.namespace,
    },
  ],
};

local k = import 'k.libsonnet';
k.core.v1.list.new(
  namespaces + serviceAccounts + [roleBinding]
)

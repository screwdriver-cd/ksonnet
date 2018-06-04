# Screwdriver via KSonnet

This repository can be used to manage a Screwdriver instance deployed into Kubernetes on AWS.

## Usage

0. Ensure [ksonnet](https://ksonnet.io/) is installed locally and [kube2iam](https://github.com/jtblin/kube2iam) is installed in the cluster.
1. Modify the `environments/default/params.libsonnet` with your specific settings (see `components/params.libsonnet` for all options).
2. Modify the `app.yaml` to point to your Kubernetes server.
3. Run `ks apply default`.

```bash
$ ks apply default
INFO Creating non-existent namespaces sd-services
INFO Creating non-existent namespaces sd-builds
INFO Creating non-existent services sd-services.sd-api
INFO Creating non-existent secrets sd-services.sd-secrets-api
INFO Creating non-existent services sd-services.sd-ui
INFO Creating non-existent serviceaccounts sd-services.sd-manager
INFO Creating non-existent serviceaccounts sd-builds.sd-builder
INFO Creating non-existent rolebindings sd-builds.sd-manager
INFO Creating non-existent services sd-services.sd-store
INFO Creating non-existent secrets sd-services.sd-secrets-store
INFO Creating non-existent deployments sd-services.sd-store
INFO Creating non-existent deployments sd-services.sd-api
INFO Creating non-existent deployments sd-services.sd-ui
```
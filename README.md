<!--- app-name` | Bitcoin Core Helm Charts -->

# Bitcoind Helm Charts

This chart bootstraps a [bitcoin](https://github.com/bitcoin/bitcoin) node on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. Bitcoin Core connects to the Bitcoin peer-to-peer network to download and fully validate blocks and transactions. It also includes a wallet and graphical user interface, which can be optionally built.

Further information about Bitcoin Core is available [here](https://github.com/bitcoin/bitcoin).


## TL;DR

```console
helm repo add bitcoind https://chipshadd.github.io/bitcoind-chart/
helm upgrade --install bitcoind bitcoind/bitcoind -n bitcoind --version 1.1.0 --create-namespace
```

This will setup a full node and 


## Introduction

This chart bootstraps a [bitcoin](https://github.com/bitcoin/bitcoin) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.20+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `bitcoind`

```bash
$  helm repo add bitcoind https://chipshadd.github.io/bitcoind-chart/
$  helm upgrade --install bitcoind bitcoind/bitcoind -n bitcoind --create-namespace
```

These commands deploy a bitcoin full node on the Kubernetes cluster using the default configuration.

> **Tip** List all releases using `helm list`


```bash
	helm list -n bitcoind
```

### Using External Secrets Operator

To use ExternalSecrets for managing RPC credentials, ensure you have the [External Secrets Operator](https://external-secrets.io/) installed in your cluster and a SecretStore configured. Then install with ExternalSecrets enabled:

```bash
helm upgrade --install bitcoind bitcoind/bitcoind -n bitcoind --create-namespace \
  --set externalSecrets.enabled=true \
  --set externalSecrets.secretStoreRef.name=my-secret-store \
  --set externalSecrets.remoteRefs.rpcuser.key=bitcoind/credentials \
  --set externalSecrets.remoteRefs.rpcpassword.key=bitcoind/credentials
```

When ExternalSecrets is enabled, the chart will create an ExternalSecret resource instead of generating local secrets, allowing credentials to be sourced from external secret management systems like AWS Secrets Manager, HashiCorp Vault, or GCP Secret Manager.

## Uninstalling the Chart

To uninstall/delete the `bitcoind` deployment

```bash
$ helm delete bitcoind -n bitcoind
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Image Parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `image.repository` | the image repository to be used | `chr1st1anh/bitcoind`  |
| `image.tag` | the image version | `22.0`  |
| `image.digest` | the image digest, use this if there is no private registry | `""`  |
| `image.pullPolicy` | pull policy | `IfNotPresent`  |

### Bitcoin Core Specific Configuration

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `configuration.rpcuser` | optional, if not quoted it will be generated | `""`  |
| `configuration.txindex` | If you want to be able to access any transaction with commands like gettransaction, you need to configure Bitcoin Core to build a complete transaction index, which can be achieved with the txindex=1. You can't use a txindex with a pruned blockchain. Pruning will throw away scanned blocks. | `1`  |
| `configuration.server` | the image repository to be used | `1`  |
| `configuration.network` | can be any of mainnet, regtest, signet or testnet, if omitted mainnet will be used only a single network per deployment is supported | `mainnet`  |
| `configuration.prune` | Autopprune (-prune=550) allows you to reduce your historical blockchain data to a given target (in MB, example uses 550 which is the minimum). You can't throw away all blocks because you may need to "roll back a couple of block" if there is a chain reorganisation. If you set prune=1 (== manual mode), you can then manually prune your blockchain (use RPC call pruneblockchain <height>) | `""`  |
| `configuration.passwordLength` | The length of the password for the RPC user | `50`  |

### External Secrets Operator Configuration

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `externalSecrets.enabled` | Enable ExternalSecrets integration to source RPC credentials from an external secret store | `false`  |
| `externalSecrets.secretStoreRef.name` | Name of the SecretStore or ClusterSecretStore resource | `""`  |
| `externalSecrets.secretStoreRef.kind` | Kind of secret store (SecretStore or ClusterSecretStore) | `SecretStore`  |
| `externalSecrets.refreshInterval` | How often to refresh the secret from the external store | `1h`  |
| `externalSecrets.remoteRefs.rpcuser.key` | Path to the RPC username secret in the external store | `""`  |
| `externalSecrets.remoteRefs.rpcuser.property` | Property within the secret for RPC username (optional) | `rpcuser`  |
| `externalSecrets.remoteRefs.rpcpassword.key` | Path to the RPC password secret in the external store | `""`  |
| `externalSecrets.remoteRefs.rpcpassword.property` | Property within the secret for RPC password (optional) | `rpcpassword`  |

### Persistent Volume Settings

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `persistence.accessMode` | Access mode of the mounted drive. | `ReadWriteOnce`  |
| `persistence.size` | Size of the mounted drive. Bitcoin on mainnet should have more than 500GB to work for a while. | `600GB`  |
| `persistence.storageClass` | The storage class used to provision the drive. | `gp2`  |


### Persistent Volume Settings

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `resources.requests.cpu` | Limits and requests for CPU resources are measured in cpu units. | `250m`  |
| `resources.requests.memory` | You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, k. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. | `1G`  |
| `resources.limits.cpu` | Limits and requests for CPU resources are measured in cpu units. | `250m`  |
| `resources.limits.memory` | You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, k. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. | `1G`  |

# Mikrolab

WARINING: EXPERIMENTAL - DOCUMENTATION AND CODE CHANGE FREQUENTLY. NOT STABLE

Mikrolab is a **sharable local Kubernetes development environment** designed to make starting a local application almost as easy as running `docker-compose up`.

It includes:

* A [React Router 7](https://reactrouter.com/) template (forked) with Mikrolab pre-integrated
* A **K3d**-based local Kubernetes cluster bootstrapper
* **Helmfile**-driven declarative GitOps install via Docker
* Out-of-the-box **ArgoCD** and **Kro** integration
* Simple ingress management with automatic TLS via Cert-Manager

---

## Features

* **One-command local cluster**: Spin up a fully configured Kubernetes cluster in seconds.
* **No local Helmfile install needed**: Helmfile runs inside a Docker container.
* **Predictable secrets management**: Store secrets in `mikrolab/.secrets` for DNS providers and private repos.
* **Declarative GitOps setup**: ArgoCD + Kro automatically install and manage resources.
* **Ingress abstraction**: Use simple `IngressRequest` objects instead of writing complex ingress manifests.
* **Optional DNS/TLS automation**: Supports DuckDNS webhook resolver or Cloudflare ClusterIssuers.

---

## Prerequisites

* [Docker](https://docs.docker.com/get-docker/) installed and running
* [Docker Compose](https://docs.docker.com/compose/install/)
* (Optional) Local installation of [K3d](https://k3d.io/) — will be installed automatically if not found.

---

## Quick Start

1. **Create a new Mikrolab app**

   ```bash
   npx create-react-router@latest test-ml --template https://github.com/rbellius/rr7-mikrolab-template
   ```

2. **Install dependencies** (if not installed by create-react-router)

   ```bash
   npm install
   ```

3. **Add required secrets**

   * Place DNS provider and private repo secrets in:

     ```
     mikrolab/.secrets/
     ```

4. **Cluster commands**

   ```bash
   npm run cluster-bootstrap       # Installs k3s, builds cluster, and deploys helmfiles
   npm run cluster-build           # Builds cluster only
   npm run cluster-rebuild         # Destroys existing cluster and rebuilds it
   npm run cluster-rebuild-apply   # Rebuilds cluster and runs helmfile apply in Docker
   npm run helmfile-apply          # Runs helmfile apply (use with cluster-build for two-step bootstrapping)
   ```

5. **Access ArgoCD**
   Once installed, ArgoCD is available at:

   ```
   https://argocd.localhost
   ```

   (Credentials are provided during install.)

---

## How It Works

### 1. Bootstrapping K3d

* Creates a default K3d config
* Mounts secrets from `.secrets`
* Stores `kubeconfig.yaml` in `mikrolab/kubeconfig.yaml`

### 2. Installing with Helmfile (via Docker)

* Helmfile container mounts kubeconfig, the local helmfile, and resources folder
* Installs **ArgoCD** and **Kro**
* Uses Helmfile hooks to wait for CRDs before continuing

### 3. Loading Resource Graph Definitions (RGDs)

* ApplicationSet installs RGDs as ArgoCD Applications
* Once healthy, local RGD instances are deployed
* `mikrolab-config` RGD installs Cert-Manager and DNS resolvers
* `IngressConfig` (ConfigMap) controls ingress defaults

### 4. Requesting an Ingress

* Create an `IngressRequest` specifying name, namespace, domain, service, and port
* Mikrolab generates ingress automatically

---

## Example: IngressRequest

```yaml
apiVersion: mikrolab.io/v1
kind: IngressRequest
metadata:
  name: my-app-ingress
  namespace: my-app
spec:
  domain: myapp.example.com
  service:
    name: my-app-service
    port: 80
```

---

## Roadmap

* [ ] CLI tool for managing Mikrolab commands
* [ ] Additional DNS provider integrations
* [ ] GitHub Actions
* [ ] Fix dynamic dns on startup (traefik not up yet)
* [ ] Create a IngressConfig rgd to standarize how ingressconfigs are set


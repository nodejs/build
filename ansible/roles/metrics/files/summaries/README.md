# summaries

## Prerequisites

- Ensure that you have following roles on GCP:
  - `Cloud Run Developer`
  - `Storage Legacy Bucket Writer`
  - `Storage Object User`
  - `Service Account User`
  - Example request: [nodejs/build#3774][cloud-run-roles-request]
- Install [Node.js][install-nodejs].
- Install [gcloud CLI][install-gcloud-cli].
  - Authenticate using [`gcloud auth`][gcloud-auth].
- Install [Docker Desktop][install-docker-desktop].
  - Authenticate using [`gcloud auth configure-docker`][gcloud-auth-docker].

## Setup

- Build Dockerfile
  - `docker buildx build --platform linux/amd64 -t gcr.io/nodejs-org/producesummaries:latest .`
- Push Docker image to GCR
  - `docker push gcr.io/nodejs-org/producesummaries:latest`
- Deploy Cloud Run service
  - `gcloud run deploy produce-summaries --image gcr.io/nodejs-org/producesummaries:latest --region us-central1 --no-allow-unauthenticated`
- If traffic is not routed to the new revision, update the service to send all traffic to the new revision
  - `gcloud run services update-traffic produce-summaries --to-latest --region us-central1`

[cloud-run-roles-request]: https://github.com/nodejs/build/issues/3774
[gcloud-auth]: https://cloud.google.com/sdk/gcloud/reference/auth
[gcloud-auth-docker]: https://cloud.google.com/sdk/gcloud/reference/auth/configure-docker
[install-docker-desktop]: https://www.docker.com/products/docker-desktop
[install-gcloud-cli]: https://cloud.google.com/sdk/docs/install
[install-nodejs]: https://nodejs.org/en/learn/getting-started/how-to-install-nodejs

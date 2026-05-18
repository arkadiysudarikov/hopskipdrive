# CI/CD Platform Demo

This repository is now a compact demo for a CI/CD platform design interview. It keeps the implementation small enough to explain in a whiteboard setting while still touching the production concerns an EM interviewer will expect: source control triggers, validation, image build, artifact publishing, deployment, health checks, rollback, and observability.

## Architecture

```mermaid
flowchart LR
  Dev[Developer PR] --> PR[GitHub Actions PR checks]
  PR --> Tests[RSpec + PostgreSQL service]
  PR --> Build[Docker image build]
  Merge[Merge to main] --> Main[GitHub Actions main pipeline]
  Main --> ECR[AWS ECR image repository]
  ECR --> K8s[Kubernetes Deployment]
  K8s --> Probes[/up liveness + /ready readiness]
  K8s --> Metrics[/metrics scrape hook]
```

## What Changed

- `Dockerfile` builds a production Rails image with Ruby 3.2.3, Bundler 2.5.6, PostgreSQL runtime libraries, Bootsnap precompilation, and a non-root runtime user.
- `.github/workflows/cicd.yml` runs tests and a Docker build for PRs, then pushes to AWS ECR and deploys to Kubernetes only after a merge to `main`.
- `k8s/` contains minimal Kubernetes manifests for a namespace, service, and rolling deployment.
- `/up` remains the Rails liveness endpoint. `/ready` now checks database connectivity for readiness.
- `/metrics` exposes a small Prometheus-compatible build info metric, and the Deployment includes scrape annotations.

## Pipeline Behavior

Pull request:

1. Check out code.
2. Start PostgreSQL as a GitHub Actions service.
3. Install Ruby dependencies with Bundler cache.
4. Prepare the test database.
5. Run `bundle exec rspec`.
6. Build the Docker image without pushing it.

Merge to `main`:

1. Reuse the same validation path.
2. Configure AWS credentials through GitHub OIDC.
3. Log in to ECR.
4. Build and push two tags: the immutable commit SHA and `main`.
5. Apply the Kubernetes manifests.
6. Update the Deployment image to the commit SHA.
7. Wait for Kubernetes rollout success.

## Required GitHub Configuration

Repository variables:

- `AWS_REGION`, for example `us-west-2`.
- `ECR_REPOSITORY`, default `hopskipdrive`.
- `EKS_CLUSTER_NAME`, default `hopskipdrive-lab`.
- `AWS_DEPLOY_ROLE_ARN`: IAM role ARN trusted by GitHub OIDC.

Kubernetes secret:

```bash
kubectl -n hopskipdrive create secret generic hopskipdrive-secrets \
  --from-literal=DATABASE_URL='postgres://USER:PASSWORD@HOST:5432/DB' \
  --from-literal=SECRET_KEY_BASE='replace-with-rails-secret'
```

## Rollback

Fast rollback to the previous ReplicaSet:

```bash
kubectl -n hopskipdrive rollout undo deployment/hopskipdrive-api
kubectl -n hopskipdrive rollout status deployment/hopskipdrive-api --timeout=120s
```

Rollback to a specific revision:

```bash
kubectl -n hopskipdrive rollout history deployment/hopskipdrive-api
kubectl -n hopskipdrive rollout undo deployment/hopskipdrive-api --to-revision=<revision>
```

Rollback to a known image tag:

```bash
kubectl -n hopskipdrive set image deployment/hopskipdrive-api \
  api=<account>.dkr.ecr.<region>.amazonaws.com/hopskipdrive:<git-sha>
kubectl -n hopskipdrive rollout status deployment/hopskipdrive-api --timeout=120s
```

## Observability Hooks

- Logs go to STDOUT with Rails request IDs, so the container runtime or cluster logging agent can collect them.
- `/metrics` provides a Prometheus scrape target for platform wiring.
- Kubernetes scrape annotations are included on the Pod template.
- Readiness failures log the exception class without exposing database details.
- Rollout status in CI gives a deployment-level signal before the workflow succeeds.

## EM Interview Tradeoffs

- GitHub Actions is good for the demo because it puts CI and CD close to the repo. At larger scale, a platform team may separate build orchestration, deployment orchestration, and policy enforcement.
- ECR is a regional artifact store. It is simple and AWS-native, but multi-region production would need replication and promotion rules.
- This demo deploys directly from Actions with `kubectl`. That is easy to explain, but mature teams often prefer GitOps with Argo CD or Flux so the cluster reconciles desired state from a deployment repo.
- Tests run before image publishing. That keeps bad builds out of ECR, but the next maturity step is adding image scanning, SBOM generation, and signed provenance.
- Readiness checks the database because this API depends on PostgreSQL. Liveness intentionally stays shallow so Kubernetes does not restart pods for a temporary downstream dependency issue.
- Rollbacks use Kubernetes Deployment history and immutable SHA image tags. Database migrations would need a separate backwards-compatibility strategy before this could be called production-safe.
- The platform does not include preview environments, canary analysis, or multi-service dependency graphs. Those are useful extensions to discuss, but they would overbuild this repository for interview practice.

## How To Explain The Design

Start with the developer workflow: PRs must prove the app builds, tests pass, and the container can be produced. Then separate release from validation: only `main` publishes an immutable artifact and deploys it. Finally, describe operational controls: readiness gates traffic, liveness restarts wedged processes, rollout status blocks bad deploys, metrics/logs support diagnosis, and rollback is a first-class command.

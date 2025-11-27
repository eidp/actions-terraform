## Examples

### Complete two-job workflow with environment approval

This is the recommended pattern for production deployments. The `environment` setting enables approval gates, and `concurrency` prevents parallel applies to the same environment.

```yaml
name: Deploy Infrastructure

on:
  push:
    branches: [main]

jobs:
  plan:
    runs-on: ubuntu-latest
    outputs:
      plan_artifact_name: ${{ steps.plan.outputs.plan_artifact_name }}
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Plan
      id: plan
      uses: eidp/actions-terraform/plan-for-apply@v1
      with:
        directory: ./terraform

  apply:
    needs: [plan]
    runs-on: ubuntu-latest
    environment: production  # Enables approval gates
    concurrency: production-apply  # Prevents parallel applies
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Apply
      id: apply
      uses: eidp/actions-terraform/apply@v1
      with:
        directory: ./terraform
        plan_artifact_name: ${{ needs.plan.outputs.plan_artifact_name }}
```

### With encrypted artifact

```yaml
jobs:
  plan:
    runs-on: ubuntu-latest
    outputs:
      plan_artifact_name: ${{ steps.plan.outputs.plan_artifact_name }}
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Plan
      id: plan
      uses: eidp/actions-terraform/plan-for-apply@v1
      with:
        encrypted_artifact_name: terraform-secrets
        artifact_identity: ${{ secrets.ARTIFACT_IDENTITY }}

  apply:
    needs: [plan]
    runs-on: ubuntu-latest
    environment: production
    concurrency: production-apply
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Apply
      uses: eidp/actions-terraform/apply@v1
      with:
        plan_artifact_name: ${{ needs.plan.outputs.plan_artifact_name }}
        encrypted_artifact_name: terraform-secrets
        artifact_identity: ${{ secrets.ARTIFACT_IDENTITY }}
```

## Examples

### Basic usage

This action is designed to be used with the `apply` action in a two-job workflow. See the `apply` action's EXAMPLES.md for complete workflow examples.

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
        directory: ./terraform
```

### With custom Terraform version and extra arguments

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
        directory: ./infrastructure/production
        terraform_version: '1.13.0'
        extra_args: '-var-file=prod.tfvars'
        extra_init_args: '-backend-config=prod.backend.hcl'
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
```

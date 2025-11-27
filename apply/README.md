<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# apply (Action)

Downloads a Terraform plan artifact and applies it.

This action is designed to be used in a two-job apply workflow where:
1. The `plan-for-apply` action runs in the first job to create and upload a plan
2. This action runs in a second job (with environment approval) to apply the plan

The second job can use GitHub's `environment` feature for approval gates
and `concurrency` for preventing parallel applies.

AWS credentials should be set as environment variables by the calling workflow.

## 🔧 Inputs

|Name                      |Description                                                                                                                                                                                          |Required|Default              |
|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------------------|
|`directory`               |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                                                   |No      |`./terraform`        |
|`extra_args`              |Extra arguments to pass to the 'terraform apply' command. Useful for (dynamically) injecting variable files or flags.                                                                                |No      |``                   |
|`extra_init_args`         |Extra arguments to pass to the 'terraform init' command.                                                                                                                                             |No      |`-lockfile=readonly` |
|`terraform_version`       |The version of Terraform to install and use.                                                                                                                                                         |No      |`1.12.2`             |
|`encrypted_artifact_name` |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.tar.age` created by the upload-encrypted-artifact action.                                         |No      |``                   |
|`artifact_identity`       |age identity (private key) used to decrypt the encrypted artifact (full contents starting with '# created:' and containing 'AGE-SECRET-KEY-'). Use the matching recipient public key when uploading. |No      |``                   |
|`debug`                   |Enable debug mode for more verbose logging. Defaults to false.                                                                                                                                       |No      |`false`              |
|`plan_artifact_name`      |Name of the plan artifact to download. This should be the `plan_artifact_name` output from the `plan-for-apply` action.                                                                              |Yes     |                     |

## 📤 Outputs

|Name            |Description                                                   |
|----------------|--------------------------------------------------------------|
|`apply_outcome` |The outcome of the Terraform apply step (success or failure). |
|`apply_output`  |The output of the Terraform apply command.                    |

## 🚀 Usage

```yaml
- name: apply
  uses: eidp/actions-terraform/apply@v0
  with:
    # your inputs here
```


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

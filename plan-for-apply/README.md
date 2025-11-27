<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# plan-for-apply (Action)

Runs a minimal Terraform plan and uploads the plan file as an artifact.

This action is designed to be used in a two-job apply workflow where:
1. This action runs in the first job to create and upload a plan
2. The `apply` action runs in a second job (with environment approval) to apply the plan

Unlike the full `plan` action, this does not include formatting checks,
validation, or PR commenting - it's purely functional for the apply workflow.

AWS credentials should be set as environment variables by the calling workflow.

## 🔧 Inputs

|Name                      |Description                                                                                                                                                                                                                    |Required|Default              |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------------------|
|`directory`               |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                                                                             |No      |`./terraform`        |
|`extra_args`              |Extra arguments to pass to the 'terraform plan' command. Useful for (dynamically) injecting variable files or flags.                                                                                                           |No      |``                   |
|`extra_init_args`         |Extra arguments to pass to the 'terraform init' command.                                                                                                                                                                       |No      |`-lockfile=readonly` |
|`terraform_version`       |The version of Terraform to install and use.                                                                                                                                                                                   |No      |`1.12.2`             |
|`encrypted_artifact_name` |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.tar.age` created by the upload-encrypted-artifact action.                                                                   |No      |``                   |
|`artifact_identity`       |age identity (private key) used to decrypt the encrypted artifact (full contents starting with '# created:' and containing 'AGE-SECRET-KEY-'). Use the matching recipient public key when uploading.                           |No      |``                   |
|`debug`                   |Enable debug mode for more verbose logging. Defaults to false.                                                                                                                                                                 |No      |`false`              |
|`command_wrapper`         |Optional command to wrap terraform commands with. Useful for credential injection tools like 1Password CLI (op run) or AWS Vault (aws-vault exec profile). Commands are executed as `[your_command] -- terraform [operation]`. |No      |``                   |

## 📤 Outputs

|Name                 |Description                                                                                                      |
|---------------------|-----------------------------------------------------------------------------------------------------------------|
|`plan_artifact_name` |The name of the uploaded plan artifact. Use this value as the `plan_artifact_name` input for the `apply` action. |
|`plan_outcome`       |The outcome of the Terraform plan step (success or failure).                                                     |
|`plan_has_changes`   |Whether the Terraform plan has changes or not.                                                                   |

## 🚀 Usage

```yaml
- name: plan-for-apply
  uses: eidp/actions-terraform/plan-for-apply@v0
  with:
    # your inputs here
```


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

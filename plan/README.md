<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# terraform-plan (Action)

Runs Terraform plan with formatting, validation, and PR commenting.

This action performs a complete Terraform plan workflow including:
- Repository checkout
- GitHub App token generation for API access
- Optional encrypted artifact download
- Terraform init, fmt, validate, and plan
- Automatic PR commenting with plan output

AWS credentials should be set as environment variables by the calling workflow.

## 🔧 Inputs

|Name                         |Description                                                                                                                                                                                                                    |Required|Default              |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------------------|
|`directory`                  |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                                                                             |No      |`./terraform`        |
|`extra_args`                 |Extra arguments to pass to the 'terraform plan' command. Useful for (dynamically) injecting variable files or flags.                                                                                                           |No      |``                   |
|`extra_init_args`            |Extra arguments to pass to the 'terraform init' command.                                                                                                                                                                       |No      |`-lockfile=readonly` |
|`terraform_version`          |The version of Terraform to install and use.                                                                                                                                                                                   |No      |`1.14.0`             |
|`encrypted_artifact_name`    |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.tar.age` created by the upload-encrypted-artifact action.                                                                   |No      |``                   |
|`artifact_identity`          |age identity (private key) used to decrypt the encrypted artifact (full contents starting with '# created:' and containing 'AGE-SECRET-KEY-'). Use the matching recipient public key when uploading.                           |No      |``                   |
|`debug`                      |Enable debug mode for more verbose logging. Defaults to false.                                                                                                                                                                 |No      |`false`              |
|`command_wrapper`            |Optional command to wrap terraform commands with. Useful for credential injection tools like 1Password CLI (op run) or AWS Vault (aws-vault exec profile). Commands are executed as `[your_command] -- terraform [operation]`. |No      |``                   |
|`github_app_id`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                 |Yes     |                     |
|`github_app_installation_id` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                    |Yes     |                     |
|`github_app_pem_file`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                           |Yes     |                     |

## 📤 Outputs

|Name           |Description                                                  |
|---------------|-------------------------------------------------------------|
|`plan_outcome` |The outcome of the Terraform plan step (success or failure). |
|`plan_output`  |The output of the Terraform plan command.                    |

## 🚀 Usage

```yaml
- name: terraform-plan
  uses: eidp/actions-terraform/plan@v0
  with:
    # your inputs here
```


## Examples

### Basic usage

```yaml
jobs:
  plan:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Plan
      uses: eidp/actions-terraform/terraform-plan@v1
      with:
        github_app_id: ${{ secrets.GITHUB_APP_ID }}
        github_app_installation_id: ${{ secrets.GITHUB_APP_INSTALLATION_ID }}
        github_app_pem_file: ${{ secrets.GITHUB_APP_PEM_FILE }}
```

### With custom directory and extra arguments

```yaml
jobs:
  plan:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Plan
      uses: eidp/actions-terraform/terraform-plan@v1
      with:
        directory: ./infrastructure/production
        terraform_version: '1.13.0'
        extra_args: '-var-file=prod.tfvars'
        extra_init_args: '-backend-config=prod.backend.hcl'
        github_app_id: ${{ secrets.GITHUB_APP_ID }}
        github_app_installation_id: ${{ secrets.GITHUB_APP_INSTALLATION_ID }}
        github_app_pem_file: ${{ secrets.GITHUB_APP_PEM_FILE }}
```

### With encrypted artifact

```yaml
jobs:
  plan:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Plan
      uses: eidp/actions-terraform/terraform-plan@v1
      with:
        encrypted_artifact_name: terraform-secrets
        artifact_identity: ${{ secrets.ARTIFACT_IDENTITY }}
        github_app_id: ${{ secrets.GITHUB_APP_ID }}
        github_app_installation_id: ${{ secrets.GITHUB_APP_INSTALLATION_ID }}
        github_app_pem_file: ${{ secrets.GITHUB_APP_PEM_FILE }}
```

### Using outputs

```yaml
jobs:
  plan:
    runs-on: ubuntu-latest
    outputs:
      plan_outcome: ${{ steps.plan.outputs.plan_outcome }}
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    steps:
    - name: Terraform Plan
      id: plan
      uses: eidp/actions-terraform/terraform-plan@v1
      with:
        github_app_id: ${{ secrets.GITHUB_APP_ID }}
        github_app_installation_id: ${{ secrets.GITHUB_APP_INSTALLATION_ID }}
        github_app_pem_file: ${{ secrets.GITHUB_APP_PEM_FILE }}

  verify:
    needs: plan
    runs-on: ubuntu-latest
    steps:
    - name: Check plan result
      run: |
        if [ "${{ needs.plan.outputs.plan_outcome }}" != "success" ]; then
          echo "Terraform plan failed"
          exit 1
        fi
```

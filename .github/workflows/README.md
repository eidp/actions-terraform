# Terraform Workflows

This repository exposes reusable GitHub workflows for managing Terraform resources.

## terraform-apply (Workflow)

This workflow can be used to apply Terraform changes to your infrastructure. 
It is designed to be run after a pull request has been merged into the `main` branch, ensuring that the changes are applied in a controlled manner.
Using GitHub environment, you can set up additional approval before applying changes.

This workflow runs the following terraform commands (in order):

1. `terraform init` - Initializes the Terraform working directory.
2. `terraform plan` - Creates an execution plan, showing what actions Terraform will take to change the infrastructure.
3. `terraform apply` - Applies the changes required to reach the desired state of the configuration.

### 🔑 GitHub authentication

GitHub authentication is handled using a [GitHub App](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps), which allows the workflow to comment on pull requests. 
In case Terraform manages GitHub resources, the GitHub App is also used to authenticate with the GitHub API.

The minimal permissions for the GitHub App are:
- `Read and write` access to `Pull requests`

<!-- BEGIN WORKFLOW INPUT DOCS: terraform-apply -->

### 🔧 Inputs

|Name                           |Description                                                                                                                                  |Required|Type   |Default              |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|--------|-------|---------------------|
|`directory`                    |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                           |No      |string |`./terraform`        |
|`environment`                  |The environment to use for the Terraform apply step. This can be used to set up extra approval before applying changes.                      |No      |string |`github`             |
|`extra_init_args`              |Extra arguments to pass to the 'terraform init' command.                                                                                     |No      |string |`-lockfile=readonly` |
|`extra_args`                   |Extra arguments to pass to the 'terraform plan' and 'terraform apply' commands.  Useful for (dynamically) injecting variable files or flags. |No      |string |``                   |
|`terraform_version`            |The version of Terraform to install and use.                                                                                                 |No      |string |`1.12.2`             |
|`encrypted_artifact_name`      |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.zip.bin` created by the encrypt action.   |No      |string |``                   |
|`encrypted_artifact_directory` |Directory where the encrypted artifact should be extracted. Defaults to the same directory as the Terraform configuration.                   |No      |string |`./terraform`        |
|`runs-on`                      |The type of runner to use for the workflow. Defaults to 'ubuntu-latest'. You can specify a different runner if needed.                       |No      |string |`ubuntu-latest`      |

### 🔐 Secrets

|Name                         |Description                                                                                                          |Required|
|-----------------------------|---------------------------------------------------------------------------------------------------------------------|--------|
|`AWS_ACCESS_KEY_ID`          |AWS access key for authenticating with Terraform providers.                                                          |Yes     |
|`AWS_SECRET_ACCESS_KEY`      |AWS secret key for authenticating with Terraform providers.                                                          |Yes     |
|`GITHUB_APP_ID`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                       |Yes     |
|`GITHUB_APP_INSTALLATION_ID` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.          |Yes     |
|`GITHUB_APP_PEM_FILE`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs. |Yes     |
|`ARTIFACT_KEY`               |Passphrase used to decrypt the encrypted artifact. Use the same value you provided to the encrypt action.            |No      |

### 📤 Outputs

|Name            |Description                                                                                                |
|----------------|-----------------------------------------------------------------------------------------------------------|
|`apply_outcome` |The status of the Terraform apply step, which can be used to determine if the apply was successful or not. |
|`apply_output`  |The output of the Terraform apply step.                                                                    |

<!-- END WORKFLOW INPUT DOCS -->

### Example Usage

```yaml
name: apply

on:
  push:
    branches:
    - main

jobs:
  plan:
    uses: eidp/actions-terraform/.github/workflows/terraform-apply.yml@v0
    with:
      directory: ./terraform
      terraform_version: '1.12.2'
      extra_args: "$(../scripts/var_files.sh .)"
      credential_file_path: path/to/credential.yml
    secrets:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      GITHUB_APP_ID: "1552622"
      GITHUB_APP_INSTALLATION_ID: "74918728"
      GITHUB_APP_PEM_FILE: ${{ secrets.GH_APP_PEM_FILE }}
      CREDENTIAL_FILE_ENCRYPTED_HEX: ${{ secrets.CREDENTIAL_FILE_ENCRYPTED_HEX }}
      CREDENTIAL_FILE_KEY: ${{ secrets.CREDENTIAL_FILE_KEY }}
```

## terraform-plan (Workflow)

This workflow can be used to review the changes made to your infrastructure code before applying them.
It is designed to be run on pull requests, allowing you to see what changes will be made without actually applying them.
The workflow creates a comment on the pull request with the output of the `terraform plan` command.

This workflow runs the following terraform commands (in order):
1. `terraform init` - Initializes the Terraform working directory.
2. `terraform fmt` - Formats the Terraform configuration files to a canonical format and style.
3. `terraform validate` - Validates the Terraform configuration files.
4. `terraform plan` - Creates an execution plan, showing what actions Terraform will take to change the infrastructure.

<!-- BEGIN WORKFLOW INPUT DOCS: terraform-plan -->

### 🔧 Inputs

|Name                           |Description                                                                                                                                |Required|Type   |Default              |
|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|--------|-------|---------------------|
|`directory`                    |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                         |No      |string |`./terraform`        |
|`extra_args`                   |Extra arguments to pass to the 'terraform plan' command.  Useful for (dynamically) injecting variable files or flags.                      |No      |string |``                   |
|`extra_init_args`              |Extra arguments to pass to the 'terraform init' command.                                                                                   |No      |string |`-lockfile=readonly` |
|`terraform_version`            |The version of Terraform to install and use.                                                                                               |No      |string |`1.12.2`             |
|`encrypted_artifact_name`      |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.zip.bin` created by the encrypt action. |No      |string |``                   |
|`encrypted_artifact_directory` |Directory where the encrypted artifact should be extracted. Defaults to the same directory as the Terraform configuration.                 |No      |string |`./terraform`        |
|`runs-on`                      |The type of runner to use for the workflow. Defaults to 'ubuntu-latest'. You can specify a different runner if needed.                     |No      |string |`ubuntu-latest`      |

### 🔐 Secrets

|Name                         |Description                                                                                                          |Required|
|-----------------------------|---------------------------------------------------------------------------------------------------------------------|--------|
|`AWS_ACCESS_KEY_ID`          |AWS access key for authenticating with Terraform providers.                                                          |Yes     |
|`AWS_SECRET_ACCESS_KEY`      |AWS secret key for authenticating with Terraform providers.                                                          |Yes     |
|`ARTIFACT_KEY`               |Passphrase used to decrypt the encrypted artifact. Use the same value you provided to the encrypt action.            |No      |
|`GITHUB_APP_ID`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                       |Yes     |
|`GITHUB_APP_INSTALLATION_ID` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.          |Yes     |
|`GITHUB_APP_PEM_FILE`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs. |Yes     |

### 📤 Outputs

|Name           |Description                                                                                               |
|---------------|----------------------------------------------------------------------------------------------------------|
|`plan_outcome` |The outcome of the Terraform plan step, which can be used to determine if the plan was successful or not. |
|`plan_output`  |The output of the Terraform plan command.                                                                 |

<!-- END WORKFLOW INPUT DOCS -->

### Example Usage

```yaml
name: plan

on:
  pull_request:
    branches:
      - main

jobs:
  plan:
    uses: eidp/actions-terraform/.github/workflows/terraform-plan.yml@v0
    with:
      directory: ./terraform
      terraform_version: '1.12.2'
      extra_args: "$(../scripts/var_files.sh .)"
      credential_file_path: path/to/credential.yml
    secrets:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      GITHUB_APP_ID: "1552622"
      GITHUB_APP_INSTALLATION_ID: "74918728"
      GITHUB_APP_PEM_FILE: ${{ secrets.GH_APP_PEM_FILE }}
      CREDENTIAL_FILE_ENCRYPTED_HEX: ${{ secrets.CREDENTIAL_FILE_ENCRYPTED_HEX }}
      CREDENTIAL_FILE_KEY: ${{ secrets.CREDENTIAL_FILE_KEY }}
```

> Tip: Use the action `eidp/actions-terraform/encrypt-credential-file@v0` to produce the ciphertext to store in `CREDENTIAL_FILE_ENCRYPTED_HEX`. See the action's README for usage: https://github.com/eidp/actions-terraform/tree/v0/encrypt-credential-file

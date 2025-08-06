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

|Name                   |Description                                                                                                                                                                                                                                                                                                                                        |Required|Type   |Default              |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-------|---------------------|
|`credential_file_path` |Path of the additional secret file (including filename) that will be created and filled with the contents of the `secrets.CREDENTIAL_FILE_BASE64`. The file path is relative to the working directory of the action. This input can be used to pass an additional credential file required by Terraform providers. Example value: `my-secret.yml`. |No      |string |``                   |
|`directory`            |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                                                                                                                                                                                                 |No      |string |`./terraform`        |
|`environment`          |The environment to use for the Terraform apply step. This can be used to set up extra approval before applying changes.                                                                                                                                                                                                                            |No      |string |`github`             |
|`extra_init_args`      |Extra arguments to pass to the 'terraform init' command.                                                                                                                                                                                                                                                                                           |No      |string |`-lockfile=readonly` |
|`extra_args`           |Extra arguments to pass to the 'terraform plan' and 'terraform apply' commands.  Useful for (dynamically) injecting variable files or flags.                                                                                                                                                                                                       |No      |string |``                   |
|`terraform_version`    |The version of Terraform to install and use.                                                                                                                                                                                                                                                                                                       |No      |string |`1.12.2`             |
|`runs-on`              |The type of runner to use for the workflow. Defaults to 'ubuntu-latest'. You can specify a different runner if needed.                                                                                                                                                                                                                             |No      |string |`ubuntu-latest`      |

### 🔐 Secrets

|Name                         |Description                                                                                                                                                                                                                                                                                                                                                |Required|
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
|`AWS_ACCESS_KEY_ID`          |AWS access key for authenticating with Terraform providers.                                                                                                                                                                                                                                                                                                |Yes     |
|`AWS_SECRET_ACCESS_KEY`      |AWS secret key for authenticating with Terraform providers.                                                                                                                                                                                                                                                                                                |Yes     |
|`GITHUB_APP_ID`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                                                                                                                                             |Yes     |
|`GITHUB_APP_INSTALLATION_ID` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                                                                                                                                |Yes     |
|`GITHUB_APP_PEM_FILE`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                                                                                                                       |Yes     |
|`CREDENTIAL_FILE_BASE64`     |Base64 encoded contents that will be written to the file specified by the `credential_file_path` input. You can use this to pass additional credentials required by Terraform providers. Encode the file contents using `base64` and set it as a secret in your GitHub repository. Example to encode a secret file: `echo -n "my-secret-content" | base64` |No      |

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
    secrets:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      GITHUB_APP_ID: "1552622"
      GITHUB_APP_INSTALLATION_ID: "74918728"
      GITHUB_APP_PEM_FILE: ${{ secrets.GH_APP_PEM_FILE }}
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

|Name                   |Description                                                                                                                                                                                                                                                                                                                                        |Required|Type   |Default              |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-------|---------------------|
|`credential_file_path` |Path of the additional secret file (including filename) that will be created and filled with the contents of the `secrets.CREDENTIAL_FILE_BASE64`. The file path is relative to the working directory of the action. This input can be used to pass an additional credential file required by Terraform providers. Example value: `my-secret.yml`. |No      |string |``                   |
|`directory`            |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                                                                                                                                                                                                 |No      |string |`./terraform`        |
|`extra_args`           |Extra arguments to pass to the 'terraform plan' command.  Useful for (dynamically) injecting variable files or flags.                                                                                                                                                                                                                              |No      |string |``                   |
|`extra_init_args`      |Extra arguments to pass to the 'terraform init' command.                                                                                                                                                                                                                                                                                           |No      |string |`-lockfile=readonly` |
|`terraform_version`    |The version of Terraform to install and use.                                                                                                                                                                                                                                                                                                       |No      |string |`1.12.2`             |
|`runs-on`              |The type of runner to use for the workflow. Defaults to 'ubuntu-latest'. You can specify a different runner if needed.                                                                                                                                                                                                                             |No      |string |`ubuntu-latest`      |

### 🔐 Secrets

|Name                         |Description                                                                                                                                                                                                                                                                                                                                                |Required|
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
|`AWS_ACCESS_KEY_ID`          |AWS access key for authenticating with Terraform providers.                                                                                                                                                                                                                                                                                                |Yes     |
|`AWS_SECRET_ACCESS_KEY`      |AWS secret key for authenticating with Terraform providers.                                                                                                                                                                                                                                                                                                |Yes     |
|`CREDENTIAL_FILE_BASE64`     |Base64 encoded contents that will be written to the file specified by the `credential_file_path` input. You can use this to pass additional credentials required by Terraform providers. Encode the file contents using `base64` and set it as a secret in your GitHub repository. Example to encode a secret file: `echo -n "my-secret-content" | base64` |No      |
|`GITHUB_APP_ID`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                                                                                                                                             |Yes     |
|`GITHUB_APP_INSTALLATION_ID` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                                                                                                                                |Yes     |
|`GITHUB_APP_PEM_FILE`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                                                                                                                                                       |Yes     |

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
    secrets:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      GITHUB_APP_ID: "1552622"
      GITHUB_APP_INSTALLATION_ID: "74918728"
      GITHUB_APP_PEM_FILE: ${{ secrets.GH_APP_PEM_FILE }}
```
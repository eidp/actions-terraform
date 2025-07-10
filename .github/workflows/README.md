## Terraform Apply (Workflow)

This workflow can be used to apply Terraform changes to your infrastructure. 
It is designed to be run after a pull request has been merged into the `main` branch, ensuring that the changes are applied in a controlled manner.
Using GitHub environment, you can set up additional approval before applying changes.

This workflow runs the following terraform commands (in order):

1. `terraform init` - Initializes the Terraform working directory.
2. `terraform plan` - Creates an execution plan, showing what actions Terraform will take to change the infrastructure.
3. `terraform apply` - Applies the changes required to reach the desired state of the configuration.

<!-- BEGIN WORKFLOW INPUT DOCS: Terraform Apply -->

### 🔧 Inputs

|        Name       |                                                                 Description                                                                |Required| Type |       Default      |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------|--------|------|--------------------|
|    `directory`    |                             Path to the directory containing Terraform configuration. Defaults to ./terraform.                             |   No   |string|    `./terraform`   |
|`terraform_version`|                                                The version of Terraform to install and use.                                                |   No   |string|      `1.12.2`      |
| `extra_init_args` |                                          Extra arguments to pass to the 'terraform init' command.                                          |   No   |string|`-lockfile=readonly`|
|    `extra_args`   |Extra arguments to pass to the 'terraform plan' and 'terraform apply' commands.  Useful for (dynamically) injecting variable files or flags.|   No   |string|         ``         |
|   `environment`   |           The environment to use for the Terraform apply step. This can be used to set up extra approval before applying changes.          |   No   |string|      `github`      |

### 🔐 Secrets

|            Name            |                                                     Description                                                    |Required|
|----------------------------|--------------------------------------------------------------------------------------------------------------------|--------|
|     `AWS_ACCESS_KEY_ID`    |                             AWS access key for authenticating with Terraform providers.                            |   Yes  |
|   `AWS_SECRET_ACCESS_KEY`  |                             AWS secret key for authenticating with Terraform providers.                            |   Yes  |
|       `GITHUB_APP_ID`      |           GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.           |   Yes  |
|    `GITHUB_APP_PEM_FILE`   |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.|   Yes  |
|`GITHUB_APP_INSTALLATION_ID`|     GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.    |   Yes  |

<!-- END WORKFLOW INPUT DOCS -->

### Example Usage

```yaml
name: 'Terraform Apply'

on:
  push:
    branches:
    - main

jobs:
  plan:
    uses: eidp/actions-terraform/.github/workflows/terraform-apply.yml@0
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

## Terraform Plan (Workflow)

This workflow can be used to review the changes made to your infrastructure code before applying them.
It is designed to be run on pull requests, allowing you to see what changes will be made without actually applying them.
The workflow creates a comment on the pull request with the output of the `terraform plan` command.

This workflow runs the following terraform commands (in order):
1. `terraform init` - Initializes the Terraform working directory.
2. `terraform fmt` - Formats the Terraform configuration files to a canonical format and style.
3. `terraform validate` - Validates the Terraform configuration files.
4. `terraform plan` - Creates an execution plan, showing what actions Terraform will take to change the infrastructure.

<!-- BEGIN WORKFLOW INPUT DOCS: Terraform Plan -->

### 🔧 Inputs

|        Name       |                                                     Description                                                     |Required| Type |       Default      |
|-------------------|---------------------------------------------------------------------------------------------------------------------|--------|------|--------------------|
|    `directory`    |                  Path to the directory containing Terraform configuration. Defaults to ./terraform.                 |   No   |string|    `./terraform`   |
|`terraform_version`|                                     The version of Terraform to install and use.                                    |   No   |string|      `1.12.2`      |
| `extra_init_args` |                               Extra arguments to pass to the 'terraform init' command.                              |   No   |string|`-lockfile=readonly`|
|    `extra_args`   |Extra arguments to pass to the 'terraform plan' command.  Useful for (dynamically) injecting variable files or flags.|   No   |string|         ``         |

### 🔐 Secrets

|            Name            |                                                     Description                                                    |Required|
|----------------------------|--------------------------------------------------------------------------------------------------------------------|--------|
|     `AWS_ACCESS_KEY_ID`    |                             AWS access key for authenticating with Terraform providers.                            |   Yes  |
|   `AWS_SECRET_ACCESS_KEY`  |                             AWS secret key for authenticating with Terraform providers.                            |   Yes  |
|       `GITHUB_APP_ID`      |           GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.           |   Yes  |
|    `GITHUB_APP_PEM_FILE`   |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.|   Yes  |
|`GITHUB_APP_INSTALLATION_ID`|     GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.    |   Yes  |

<!-- END WORKFLOW INPUT DOCS -->

### Example Usage

```yaml
name: 'Terraform Plan'

on:
  pull_request:
    branches:
      - main

jobs:
  plan:
    uses: eidp/actions-terraform/.github/workflows/terraform-plan.yml@main
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
## terraform-apply (Workflow)

<!-- BEGIN WORKFLOW INPUT DOCS: terraform-apply -->

### 🔧 Inputs

|Name                      |Description                                                                                                                                                                |Required|Type    |Default              |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|--------|---------------------|
|`directory`               |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                         |No      |string  |`./terraform`        |
|`environment`             |The environment to use for the Terraform apply step. This can be used to set up extra approval before applying changes.                                                    |No      |string  |`github`             |
|`extra_init_args`         |Extra arguments to pass to the 'terraform init' command.                                                                                                                   |No      |string  |`-lockfile=readonly` |
|`extra_args`              |Extra arguments to pass to the 'terraform plan' and 'terraform apply' commands. Useful for (dynamically) injecting variable files or flags.                                |No      |string  |``                   |
|`terraform_version`       |The version of Terraform to install and use.                                                                                                                               |No      |string  |`1.12.2`             |
|`encrypted_artifact_name` |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.tar.age` created by the upload-encrypted-artifact action.               |No      |string  |``                   |
|`runs-on`                 |The type of runner to use for the workflow. Defaults to 'ubuntu-latest'. You can specify a different runner if needed.                                                     |No      |string  |`ubuntu-latest`      |
|`debug`                   |Enable debug mode for more verbose logging. Defaults to false.                                                                                                             |No      |boolean |`false`              |
|`command_wrapper`         |Optional command wrapper to prefix terraform commands with. Useful for credential injection tools like 1Password CLI (op run --) or AWS Vault (aws-vault exec profile --). |No      |string  |``                   |

### 🔐 Secrets

|Name                         |Description                                                                                                                                                                                          |Required|
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
|`AWS_ACCESS_KEY_ID`          |AWS access key for authenticating with Terraform providers.                                                                                                                                          |Yes     |
|`AWS_SECRET_ACCESS_KEY`      |AWS secret key for authenticating with Terraform providers.                                                                                                                                          |Yes     |
|`GITHUB_APP_ID`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                       |Yes     |
|`GITHUB_APP_INSTALLATION_ID` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                          |Yes     |
|`GITHUB_APP_PEM_FILE`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                 |Yes     |
|`ARTIFACT_IDENTITY`          |age identity (private key) used to decrypt the encrypted artifact (full contents starting with '# created:' and containing 'AGE-SECRET-KEY-'). Use the matching recipient public key when uploading. |No      |

### 📤 Outputs

|Name            |Description                                                                                                |
|----------------|-----------------------------------------------------------------------------------------------------------|
|`apply_outcome` |The status of the Terraform apply step, which can be used to determine if the apply was successful or not. |
|`apply_output`  |The output of the Terraform apply step.                                                                    |

<!-- END WORKFLOW INPUT DOCS -->

## terraform-plan (Workflow)

<!-- BEGIN WORKFLOW INPUT DOCS: terraform-plan -->

### 🔧 Inputs

|Name                      |Description                                                                                                                                                                |Required|Type    |Default              |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|--------|---------------------|
|`directory`               |Path to the directory containing Terraform configuration. Defaults to ./terraform.                                                                                         |No      |string  |`./terraform`        |
|`extra_args`              |Extra arguments to pass to the 'terraform plan' command. Useful for (dynamically) injecting variable files or flags.                                                       |No      |string  |``                   |
|`extra_init_args`         |Extra arguments to pass to the 'terraform init' command.                                                                                                                   |No      |string  |`-lockfile=readonly` |
|`terraform_version`       |The version of Terraform to install and use.                                                                                                                               |No      |string  |`1.12.2`             |
|`encrypted_artifact_name` |Name of the encrypted artifact to download. The artifact must contain a single file named `archive.tar.age` created by the upload-encrypted-artifact action.               |No      |string  |``                   |
|`runs-on`                 |The type of runner to use for the workflow. Defaults to 'ubuntu-latest'. You can specify a different runner if needed.                                                     |No      |string  |`ubuntu-latest`      |
|`debug`                   |Enable debug mode for more verbose logging. Defaults to false.                                                                                                             |No      |boolean |`false`              |
|`command_wrapper`         |Optional command wrapper to prefix terraform commands with. Useful for credential injection tools like 1Password CLI (op run --) or AWS Vault (aws-vault exec profile --). |No      |string  |``                   |

### 🔐 Secrets

|Name                         |Description                                                                                                                                                                                          |Required|
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
|`AWS_ACCESS_KEY_ID`          |AWS access key for authenticating with Terraform providers.                                                                                                                                          |Yes     |
|`AWS_SECRET_ACCESS_KEY`      |AWS secret key for authenticating with Terraform providers.                                                                                                                                          |Yes     |
|`ARTIFACT_IDENTITY`          |age identity (private key) used to decrypt the encrypted artifact (full contents starting with '# created:' and containing 'AGE-SECRET-KEY-'). Use the matching recipient public key when uploading. |No      |
|`GITHUB_APP_ID`              |GitHub App ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                                       |Yes     |
|`GITHUB_APP_INSTALLATION_ID` |GitHub App Installation ID used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                          |Yes     |
|`GITHUB_APP_PEM_FILE`        |GitHub App private key (PEM format) used by Terraform to authenticate with the GitHub API and for commenting on PRs.                                                                                 |Yes     |

### 📤 Outputs

|Name           |Description                                                                                               |
|---------------|----------------------------------------------------------------------------------------------------------|
|`plan_outcome` |The outcome of the Terraform plan step, which can be used to determine if the plan was successful or not. |
|`plan_output`  |The output of the Terraform plan command.                                                                 |

<!-- END WORKFLOW INPUT DOCS -->

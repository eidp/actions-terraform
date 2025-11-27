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

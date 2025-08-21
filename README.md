# Terraform Actions and Workflows

This repository contains GitHub Actions and shared workflows for managing Terraform resources.

<!-- BEGIN ACTIONS -->

## 🛠️ GitHub Actions

The following GitHub Actions are available in this repository:

- [download-encrypted-artifact](download-encrypted-artifact/README.md)
- [upload-encrypted-artifact](upload-encrypted-artifact/README.md)

<!-- END ACTIONS -->

<!-- BEGIN SHARED WORKFLOWS -->

## 📚 Shared Workflows

The following reusable workflows are available in this repository:

- [terraform-apply](./.github/workflows/README.md#terraform-apply-workflow)
- [terraform-plan](./.github/workflows/README.md#terraform-plan-workflow)

<!-- END SHARED WORKFLOWS -->

## Development

### Pre-commit hooks

To ensure code quality and consistency, this repository uses [pre-commit](https://pre-commit.com/) hooks. Make sure to
install the pre-commit hooks by running:

```bash
pre-commit install
```

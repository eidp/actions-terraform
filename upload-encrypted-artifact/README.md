<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# upload-encrypted-artifact (Action)

This action creates an encrypted artifact.

This action archives the provided paths into a file named `archive.tar`, encrypts it producing `archive.tar.age`, and uploads the encrypted file as an artifact.
- Encryption tool: age (https://age-encryption.org)
- Mode: recipient public key (X25519)

Important:
- Provide an age recipient public key (age1...) via the `recipient` input.
- Use the matching `download-encrypted-artifact` action with the corresponding private identity key to decrypt and extract.

## 🔧 Inputs

|Name            |Description                                                                                                                                                                                                            |Required|Default              |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------------------|
|`directory`     |Directory to run the action in. Defaults to the current working directory. If provided, the action will change to this directory before creating the archive. This is where the archive will be created and encrypted. |No      |``                   |
|`paths`         |Space-separated list of files/directories to include in the archive. Globs are supported by the shell.                                                                                                                 |Yes     |                     |
|`recipient`     |age recipient public key (starts with age1...).                                                                                                                                                                        |Yes     |                     |
|`artifact_name` |Name of the artifact to upload.                                                                                                                                                                                        |No      |`encrypted-artifact` |

## 📤 Outputs

_None_

## 🚀 Usage

```yaml
- name: upload-encrypted-artifact
  uses: eidp/actions-terraform/upload-encrypted-artifact@v0
  with:
    # your inputs here
```

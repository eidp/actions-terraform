<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# download-encrypted-artifact (Action)

Downloads an encrypted artifact file, decrypts it and extract its contents.

This action downloads an artifact containing `archive.tar.age`, decrypts it to `archive.tar` and extracts (untars) into the target directory.
- Encryption tool: age (https://age-encryption.org)
- Mode: identity (private key) decryption (X25519)

## 🔧 Inputs

|Name             |Description                                                                                                                                                                  |Required|Default              |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|---------------------|
|`directory`      |Directory to run the action in (defaults to current working directory).                                                                                                      |No      |``                   |
|`artifact_name`  |Name of the artifact to download that contains `archive.tar.age`.                                                                                                            |No      |`encrypted-artifact` |
|`encrypted_file` |Path to the encrypted archive file (archive.tar.age). If not provided, defaults to `archive.tar.age` in the current directory when an artifact is downloaded.                |No      |``                   |
|`identity`       |age identity (private key) used for decryption. Provide the full contents (starts with `# created:` and contains a line starting with `AGE-SECRET-KEY-`). Store as a secret. |Yes     |                     |
|`out_dir`        |Directory to extract the decrypted archive into (defaults to current working directory).                                                                                     |No      |`.`                  |
|`cleanup`        |Whether to remove archive.tar and archive.tar.age after extraction (true/false, default true).                                                                               |No      |`true`               |

## 📤 Outputs

_None_

## 🚀 Usage

```yaml
- name: download-encrypted-artifact
  uses: eidp/actions-terraform/download-encrypted-artifact@v0
  with:
    # your inputs here
```

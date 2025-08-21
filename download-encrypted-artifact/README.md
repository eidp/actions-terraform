<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# download-encrypted-artifact (Action)

Downloads an encrypted artifact file, decrypts it and extract its contents.

This action downloads an artifact containing `archive.tar.bin`, decrypts it to `archive.tar` and extracts (untars) into the target directory.
- Cipher: OpenSSL symmetric cipher (default: aes-256-cbc)
- KDF: pbkdf2 with salt (OpenSSL default for `-pbkdf2 -salt`)

## 🔧 Inputs

|      Name      |                                                                         Description                                                                         |Required|       Default      |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|--------------------|
|   `directory`  |                                           Directory to run the action in (defaults to current working directory).                                           |   No   |         ``         |
| `artifact_name`|                                              Name of the artifact to download that contains `archive.tar.bin`.                                              |   No   |`encrypted-artifact`|
|`encrypted_file`|Path to the encrypted archive file (archive.tar.bin). If not provided, defaults to `archive.tar.bin` in the current directory when an artifact is downloaded.|   No   |         ``         |
|      `key`     |                                                Passphrase used for encryption/decryption (store as a secret).                                               |   Yes  |                    |
|    `out_dir`   |                                   Directory to extract the decrypted archive into (defaults to current working directory).                                  |   No   |         `.`        |
|    `cipher`    |                                                          OpenSSL cipher used (default aes-256-cbc).                                                         |   No   |                    |
|    `cleanup`   |                                Whether to remove archive.tar and archive.tar.bin after extraction (true/false, default true).                               |   No   |       `true`       |

## 📤 Outputs

_None_

## 🚀 Usage

```yaml
- name: download-encrypted-artifact
  uses: eidp/actions-terraform/download-encrypted-artifact@v0
  with:
    # your inputs here
```

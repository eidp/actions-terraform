<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# download-encrypted-artifact (Action)

Downloads an encrypted artifact file, decrypts it and extract its contents.

This action downloads an artifact containing `archive.zip.bin`, decrypts it to `archive.zip` and unzips into the target directory.
- Cipher: OpenSSL symmetric cipher (default: aes-256-cbc)
- KDF: pbkdf2 with salt (OpenSSL default for `-pbkdf2 -salt`)

## 🔧 Inputs

|      Name      |                                                                     Description                                                                     |Required|       Default      |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|--------|--------------------|
| `artifact_name`|                                          Name of the artifact to download that contains `archive.zip.bin`.                                          |   No   |`encrypted-artifact`|
|`encrypted_file`|Path to the encrypted archive file (archive.zip.bin). If not provided, defaults to `${download_path}/archive.zip.bin` when an artifact is downloaded.|   No   |         ``         |
|      `key`     |                                            Passphrase used for encryption/decryption (store as a secret).                                           |   Yes  |                    |
|    `out_dir`   |                               Directory to extract the decrypted archive into (defaults to current working directory).                              |   No   |         `.`        |
|    `cipher`    |                                                      OpenSSL cipher used (default aes-256-cbc).                                                     |   No   |                    |
|    `cleanup`   |                            Whether to remove archive.zip and archive.zip.bin after extraction (true/false, default true).                           |   No   |       `true`       |

## 📤 Outputs

_None_

## 🚀 Usage

```yaml
- name: download-encrypted-artifact
  uses: eidp/actions-terraform/download-encrypted-artifact@v0
  with:
    # your inputs here
```

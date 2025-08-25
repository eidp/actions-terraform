<!-- NOTE: This file's contents are automatically generated. Do not edit manually. -->
# upload-encrypted-artifact (Action)

This action creates an encrypted artifact.

This action archives the provided paths into a file named `archive.tar`, encrypts it producing `archive.tar.bin`, and uploads the encrypted file as an artifact.
- Cipher: OpenSSL symmetric cipher (default: aes-256-cbc)
- KDF: pbkdf2 with salt (OpenSSL default for `-pbkdf2 -salt`)

Important:
- Do NOT echo the passphrase (key). Keep it only in GitHub secrets.
- Use the matching `download-encrypted-artifact` action to download, decrypt, and extract (untar) the archive in consumer workflows.

## 🔧 Inputs

|      Name     |                                              Description                                             |Required|       Default      |
|---------------|------------------------------------------------------------------------------------------------------|--------|--------------------|
|    `paths`    |Space-separated list of files/directories to include in the archive. Globs are supported by the shell.|   Yes  |                    |
|     `key`     |                Passphrase to use for encryption (store as a secret in your workflow).                |   Yes  |                    |
|    `cipher`   |                                 OpenSSL cipher to use for encryption.                                |   No   |    `aes-256-cbc`   |
|`artifact_name`|                                    Name of the artifact to upload.                                   |   No   |`encrypted-artifact`|

## 📤 Outputs

_None_

## 🚀 Usage

```yaml
- name: upload-encrypted-artifact
  uses: eidp/actions-terraform/upload-encrypted-artifact@v0
  with:
    # your inputs here
```

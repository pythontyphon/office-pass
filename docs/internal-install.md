# Internal Install Fallback

Use this path if Homebrew tap access is unavailable.

## Requirements

- A hosted office-pass binary in an internal artifact store.
- A published SHA256 checksum for that binary.

## Install command

```bash
OFFICE_PASS_DOWNLOAD_URL="https://artifacts.example.com/tools/office-pass/0.1.0/office-pass-macos-arm64" \
OFFICE_PASS_SHA256="replace_with_real_sha256" \
./scripts/install-internal.sh
```

Optional install location override:

```bash
OFFICE_PASS_INSTALL_DIR="$HOME/.local/bin" \
OFFICE_PASS_DOWNLOAD_URL="https://artifacts.example.com/tools/office-pass/0.1.0/office-pass-macos-arm64" \
OFFICE_PASS_SHA256="replace_with_real_sha256" \
./scripts/install-internal.sh
```

## Verify

```bash
office-pass --help
```

## Security note

Always verify the SHA256 value from a trusted internal source before running install.

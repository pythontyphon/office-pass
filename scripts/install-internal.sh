#!/usr/bin/env bash
set -euo pipefail

# Installs office-pass binary from an internal artifact URL with SHA256 verification.
# Required env vars:
#   OFFICE_PASS_DOWNLOAD_URL
#   OFFICE_PASS_SHA256
# Optional env vars:
#   OFFICE_PASS_INSTALL_DIR (default chooses /opt/homebrew/bin if present, otherwise /usr/local/bin)

if [[ -z "${OFFICE_PASS_DOWNLOAD_URL:-}" ]]; then
  echo "Missing OFFICE_PASS_DOWNLOAD_URL"
  exit 2
fi

if [[ -z "${OFFICE_PASS_SHA256:-}" ]]; then
  echo "Missing OFFICE_PASS_SHA256"
  exit 2
fi

if [[ -n "${OFFICE_PASS_INSTALL_DIR:-}" ]]; then
  INSTALL_DIR="${OFFICE_PASS_INSTALL_DIR}"
else
  if [[ -d "/opt/homebrew/bin" ]]; then
    INSTALL_DIR="/opt/homebrew/bin"
  else
    INSTALL_DIR="/usr/local/bin"
  fi
fi

TMP_FILE="$(mktemp -t office-pass-bin.XXXXXX)"
cleanup() {
  rm -f "${TMP_FILE}"
}
trap cleanup EXIT

echo "Downloading office-pass from internal source"
curl -fsSL -o "${TMP_FILE}" "${OFFICE_PASS_DOWNLOAD_URL}"

ACTUAL_SHA256="$(shasum -a 256 "${TMP_FILE}" | awk '{print $1}')"
if [[ "${ACTUAL_SHA256}" != "${OFFICE_PASS_SHA256}" ]]; then
  echo "Checksum mismatch"
  echo "Expected: ${OFFICE_PASS_SHA256}"
  echo "Actual:   ${ACTUAL_SHA256}"
  exit 1
fi

chmod +x "${TMP_FILE}"
mkdir -p "${INSTALL_DIR}"
cp "${TMP_FILE}" "${INSTALL_DIR}/office-pass"

echo "Installed to ${INSTALL_DIR}/office-pass"
echo "Run: office-pass --help"

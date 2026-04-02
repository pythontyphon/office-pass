#!/usr/bin/env bash
set -euo pipefail

# Prepares URL and SHA256 values for Formula/office-pass.rb from a GitHub source tag.
# Usage: ./scripts/release-homebrew-source.sh v0.1.0

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <tag>"
  exit 2
fi

TAG="$1"
OWNER_REPO="${OFFICE_PASS_REPO:-pythontyphon/office-pass}"
FORMULA_FILE="Formula/office-pass.rb"
TARBALL_URL="https://github.com/${OWNER_REPO}/archive/refs/tags/${TAG}.tar.gz"
TMP_FILE="$(mktemp -t office-pass-tarball.XXXXXX)"

cleanup() {
  rm -f "${TMP_FILE}"
}
trap cleanup EXIT

echo "Downloading source tarball: ${TARBALL_URL}"
curl -fsSL -o "${TMP_FILE}" "${TARBALL_URL}"

SHA256="$(shasum -a 256 "${TMP_FILE}" | awk '{print $1}')"

echo "Computed SHA256: ${SHA256}"

echo "Updating ${FORMULA_FILE}"
sed -i '' -E "s|^  url \".*\"|  url \"${TARBALL_URL}\"|" "${FORMULA_FILE}"
sed -i '' -E "s|^  sha256 \".*\"|  sha256 \"${SHA256}\"|" "${FORMULA_FILE}"

echo "Done. Review and commit ${FORMULA_FILE}."

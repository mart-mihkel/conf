#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

DESTINATION="${1:-build/vendor}"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

HEADERS=(-H 'Accept: application/vnd.github+json' -H 'User-Agent: sapu-vendor-fetcher')

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    HEADERS+=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

log "checking latest pi release..."
curl -fsSL "${HEADERS[@]}" https://api.github.com/repos/earendil-works/pi/releases/latest > "${WORKDIR}/pi.json"
PI_TAG="$(jq -er '.tag_name' "${WORKDIR}/pi.json")"
PI_URL="$(jq -er '.assets[] | select(.name == "pi-linux-x64.tar.gz") | .browser_download_url' "${WORKDIR}/pi.json")"
PI_DIGEST="$(jq -er '.assets[] | select(.name == "pi-linux-x64.tar.gz") | .digest | select(startswith("sha256:"))' "${WORKDIR}/pi.json")"

log "downloading pi $PI_TAG..."
curl -fsSL "$PI_URL" > "${WORKDIR}/pi-linux-x64.tar.gz"
ACTUAL="$(shasum -a 256 "${WORKDIR}/pi-linux-x64.tar.gz")"

if [[ "${ACTUAL%% *}" != "${PI_DIGEST#sha256:}" ]]; then
    error "SHA-256 mismatch for pi-linux-x64.tar.gz"
    exit 1
fi

log "checking latest llama.cpp build release..."
curl -fsSL "${HEADERS[@]}" 'https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=1' > "${WORKDIR}/llama.json"
LLAMA_TAG="$(jq -er '.[0].tag_name | select(test("^b[0-9]+$"))' "${WORKDIR}/llama.json")"
LLAMA_URL="$(jq -er '.[0].tarball_url' "${WORKDIR}/llama.json")"

log "downloading llama.cpp $LLAMA_TAG source..."
curl -fsSL "$LLAMA_URL" > "${WORKDIR}/llama.cpp.tar.gz"
tar -tzf "${WORKDIR}/llama.cpp.tar.gz" > /dev/null

BLE_VERSION="0.4.0-devel3"
BLE_SHA256="c8612ee612bc6b10dbfd6e85c6cbdfd7caf152a12d1f9de22ea0a9d735b3080c"

log "downloading ble.sh $BLE_VERSION..."
curl -fsSL "https://github.com/akinomyoga/ble.sh/releases/download/v${BLE_VERSION}/ble-${BLE_VERSION}.tar.xz" > "${WORKDIR}/ble.tar.xz"
ACTUAL="$(shasum -a 256 "${WORKDIR}/ble.tar.xz")"

if [[ "${ACTUAL%% *}" != "$BLE_SHA256" ]]; then
    error "SHA-256 mismatch for ble.sh $BLE_VERSION"
    exit 1
fi

xz -dc "${WORKDIR}/ble.tar.xz" | gzip -c > "${WORKDIR}/ble.tar.gz"
tar -tzf "${WORKDIR}/ble.tar.gz" > /dev/null

printf 'pi %s\nllama.cpp %s\nble.sh %s\n' "$PI_TAG" "$LLAMA_TAG" "$BLE_VERSION" > "${WORKDIR}/versions.txt"

(cd "$WORKDIR" && shasum -a 256 pi-linux-x64.tar.gz llama.cpp.tar.gz ble.tar.gz versions.txt > SHA256SUMS)
mkdir -p "$DESTINATION"

for file in pi-linux-x64.tar.gz llama.cpp.tar.gz ble.tar.gz versions.txt SHA256SUMS; do
    cp "${WORKDIR}/$file" "${DESTINATION}/$file"
done

log "vendor archives ready in $DESTINATION"

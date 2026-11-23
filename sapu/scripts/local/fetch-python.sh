#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

if [[ $# -eq 0 ]]; then
    error "provide at least one Python version, for example 3.12 3.13"
    exit 1
fi

DESTINATION="build/python"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

mkdir -p "$DESTINATION"

for version in "$@"; do
    log "looking up Python $version in uv's download catalog..."
    uv python list "$version" --all-platforms --all-arches --only-downloads --show-urls --output-format json > "${WORKDIR}/downloads.json"
    count="$(jq '[.[] | select(.implementation == "cpython" and .os == "linux" and .arch == "x86_64" and .libc == "gnu" and .variant == "default")] | length' "${WORKDIR}/downloads.json")"

    if [[ "$count" != 1 ]]; then
        error "expected one Linux x86-64 GNU CPython download for $version, found $count"
        exit 1
    fi

    key="$(jq -er '.[] | select(.implementation == "cpython" and .os == "linux" and .arch == "x86_64" and .libc == "gnu" and .variant == "default") | .key' "${WORKDIR}/downloads.json")"
    url="$(jq -er '.[] | select(.implementation == "cpython" and .os == "linux" and .arch == "x86_64" and .libc == "gnu" and .variant == "default") | .url' "${WORKDIR}/downloads.json")"

    log "downloading $key..."
    curl -fsSL "$url" > "${WORKDIR}/$key.tar.gz"
    tar -tzf "${WORKDIR}/$key.tar.gz" > /dev/null
    mv "${WORKDIR}/$key.tar.gz" "${DESTINATION}/$key.tar.gz"
    log "downloaded $key"
done

(cd "$DESTINATION" && shasum -a 256 ./*.tar.gz > SHA256SUMS)
log "Python archives ready in $DESTINATION"

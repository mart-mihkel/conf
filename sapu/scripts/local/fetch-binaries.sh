#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

DESTINATION="${1:-build/bin}"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

mkdir -p "$DESTINATION"
DESTINATION="$(cd "$DESTINATION" && pwd)"

fetch() {
    local repo="$1"
    local pattern="$2"
    local binaries="$3"
    local tag
    local name
    local url
    local digest
    local actual
    local binary
    local member
    local count
    local -a headers=(-H 'Accept: application/vnd.github+json' -H 'User-Agent: sapu-binary-fetcher')

    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        headers+=(-H "Authorization: Bearer $GITHUB_TOKEN")
    fi

    log "checking latest release of $repo..."
    curl -fsSL "${headers[@]}" \
        "https://api.github.com/repos/$repo/releases/latest" > "${WORKDIR}/release.json"

    tag="$(jq -er '.tag_name' "${WORKDIR}/release.json")"
    name="${pattern//\{tag\}/$tag}"
    name="${name//\{version\}/${tag#v}}"
    count="$(jq --arg name "$name" '[.assets[] | select(.name == $name)] | length' "${WORKDIR}/release.json")"

    if [[ "$count" != 1 ]]; then
        error "expected one asset named $name in $repo $tag"
        return 1
    fi

    url="$(jq -er --arg name "$name" '.assets[] | select(.name == $name) | .browser_download_url' "${WORKDIR}/release.json")"
    digest="$(jq -er --arg name "$name" '.assets[] | select(.name == $name) | .digest | select(startswith("sha256:"))' "${WORKDIR}/release.json")"

    log "downloading $name..."
    curl -fsSL "$url" > "${WORKDIR}/archive.tar.gz"
    actual="$(shasum -a 256 "${WORKDIR}/archive.tar.gz")"
    actual="${actual%% *}"

    if [[ "$actual" != "${digest#sha256:}" ]]; then
        error "SHA-256 mismatch for $name"
        return 1
    fi

    if [[ "$name" == *.tar.gz ]]; then
        tar -tzf "${WORKDIR}/archive.tar.gz" > "${WORKDIR}/members"
    fi

    for binary in $binaries; do
        if [[ "$name" == *.tar.gz ]]; then
            member="$(awk -v binary="$binary" '($0 == binary || $0 ~ ("/" binary "$")) { print }' "${WORKDIR}/members")"
            count="$(printf '%s\n' "$member" | awk 'NF { n++ } END { print n+0 }')"

            if [[ "$count" != 1 ]]; then
                error "expected one $binary in $name"
                return 1
            fi

            tar -xOzf "${WORKDIR}/archive.tar.gz" "$member" > "${WORKDIR}/$binary"
        else
            cp "${WORKDIR}/archive.tar.gz" "${WORKDIR}/$binary"
        fi

        chmod 755 "${WORKDIR}/$binary"

        cp "${WORKDIR}/$binary" "${DESTINATION}/.$binary.tmp"
        mv -f "${DESTINATION}/.$binary.tmp" "${DESTINATION}/$binary"
    done

    log "downloaded $repo $tag: $binaries"
}

fetch astral-sh/uv 'uv-x86_64-unknown-linux-musl.tar.gz' 'uv uvx'
fetch sharkdp/bat 'bat-{tag}-x86_64-unknown-linux-musl.tar.gz' 'bat'
fetch sharkdp/fd 'fd-{tag}-x86_64-unknown-linux-musl.tar.gz' 'fd'
fetch eza-community/eza 'eza_x86_64-unknown-linux-musl.tar.gz' 'eza'
fetch casey/just 'just-{version}-x86_64-unknown-linux-musl.tar.gz' 'just'
fetch direnv/direnv 'direnv.linux-amd64' 'direnv'

#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ARCHIVE="/storage/data/input/input_mart_mihkel/vendor/pi-linux-x64.tar.gz"
INSTALL="${HOME}/.local/opt"
DEST="${INSTALL}/pi"
BIN="${HOME}/.local/bin"
LINK="${BIN}/pi"
CONF="${HOME}/.pi/agent"

if [[ ! -f "$ARCHIVE" ]]; then
    error "archive not found: $ARCHIVE"
    exit 1
fi

if [[ -d "$LINK" && ! -L "$LINK" ]]; then
    error "binary path is a directory: $LINK"
    exit 1
fi

mkdir -p "$INSTALL" "$BIN" "$CONF"
WORKDIR="$(mktemp -d "${INSTALL}/.pi-install.XXXXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

log "unpacking Pi..."
mkdir "${WORKDIR}/pi"
tar -xzf "$ARCHIVE" --strip-components=1 -C "${WORKDIR}/pi"

if [[ ! -f "${WORKDIR}/pi/pi" || ! -x "${WORKDIR}/pi/pi" ]]; then
    error "archive does not contain an executable pi/pi"
    exit 1
fi

cat > "${WORKDIR}/auth.json" <<'EOF'
{
  "llama.cpp": {
    "type": "api_key",
    "env": {
      "LLAMA_BASE_URL": "http://127.0.0.1:9931"
    }
  }
}
EOF

cat > "${WORKDIR}/AGENTS.md" <<'EOF'
## Environment

You are running in SAPU (sensitiivsete andmete privaatne uurimiskeskkond). The private research environment for sensitive data called SAPU, is a secure computing environment designed and offered by the University of Tartu HPC Center (UT HPC). In SAPU environment analysts can work on sensitive data, reducing the possibility of unauthorized copying, transfer or extraction of data and offering a higher security level than a standard high-performance computing cluster. The SAPU environment is a special and separate virtual machine that meets high-security requirements and is located in the UT HPC data center in Estonia.

- Internet access is disabled with some exceptions. You have network access to PyPI and CRAN.
- Data can be moved into the SAPU environment only via object storage synced every few minutes to `/data/storage/input` and out from the SAPU environment only with the consent, supervision and manual review of the data owner.
- Without exception, all user activities are logged and can be audited.
EOF

rm -rf "$DEST"
mv "${WORKDIR}/pi" "$DEST"
rm -f "$LINK"
ln -s "${DEST}/pi" "$LINK"
log "installed Pi to $DEST and linked $LINK"

if [[ ! -e "$CONF/auth.json" && ! -L "$CONF/auth.json" ]]; then
    install -m 600 "${WORKDIR}/auth.json" "${CONF}/auth.json"
fi

if [[ ! -e "$CONF/AGENTS.md" && ! -L "$CONF/AGENTS.md" ]]; then
    install -m 644 "${WORKDIR}/AGENTS.md" "${CONF}/AGENTS.md"
fi

log "configured Pi in $CONF"

if [[ ":${PATH:-}:" != *":$BIN:"* ]]; then
    printf 'Add ~/.local/bin to PATH in ~/.bashrc? [y/N] '
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        cat >> "${HOME}/.bashrc" <<'EOF'

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF
        log "added ~/.local/bin to PATH in ~/.bashrc"
        log "restart your shell or 'source ~/.bashrc'"
    fi
fi

log "use '/llama' in Pi to list and load/unload models"

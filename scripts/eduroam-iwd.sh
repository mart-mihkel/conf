#!/usr/bin/env bash

set -euo pipefail

ok()   { printf "\033[1;32minfo\033[0m %s\n" "$*"; }
log()  { printf "\033[1;34minfo\033[0m %s\n" "$*"; }

log "login: "
read -r LOGIN

log "password: "
read -rs PASSWORD

sudo tee /var/lib/iwd/eduroam.8021x > /dev/null << EOF
[Security]
EAP-Method=PEAP
EAP-Identity=${LOGIN}
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=${LOGIN}
EAP-PEAP-Phase2-Password=${PASSWORD}

[Settings]
AutoConnect=true
EOF

ok "connection added"

#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s" "$(date '+%H:%M:%S')" "$*"; }

log "login: "
read LOGIN

log "password: "
read -s PASSWORD

sudo cat << EOF > /var/lib/iwd/eduroam.8021x
[Security]
EAP-Method=PEAP
EAP-Identity=${LOGIN}
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=${LOGIN}
EAP-PEAP-Phase2-Password=${PASSWORD}

[Settings]
AutoConnect=true
EOF

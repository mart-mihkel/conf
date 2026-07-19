#!/usr/bin/env bash

set -euo pipefail

log()  { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }

log "login: "
read -r LOGIN

log "password: "
read -rs PASSWORD

nmcli con add \
    type wifi \
    ifname wlp2s0 \
    con-name eduroam \
    ssid eduroam \
    ipv4.method auto \
    802-1x.eap peap \
    802-1x.phase2-auth mschapv2 \
    802-1x.identity "$LOGIN" \
    802-1x.password "$PASSWORD" \
    wifi-sec.key-mgmt wpa-eap

log "connection added"

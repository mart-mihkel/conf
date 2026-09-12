#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*"; }

IFNAME=

if [ -z "$IFNAME" ]; then
    error "wireless interface is unset"
    error "exiting with error"
    exit 1
fi

log "login: "
read -r LOGIN

log "password: "
read -rs PASSWORD

nmcli con add \
    type wifi \
    ifname "$IFNAME" \
    con-name eduroam \
    ssid eduroam \
    ipv4.method auto \
    802-1x.eap peap \
    802-1x.phase2-auth mschapv2 \
    802-1x.identity "$LOGIN" \
    802-1x.password "$PASSWORD" \
    wifi-sec.key-mgmt wpa-eap

log "connection added"

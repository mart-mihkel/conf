#!/usr/bin/env bash

set -euo pipefail

log() { printf "\033[1;34m[%s]\033[0m %s" "$(date '+%H:%M:%S')" "$*"; }

log "login: "
read LOGIN

log "password: "
read -s PASSWORD

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

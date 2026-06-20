#!/usr/bin/env bash

log() { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

PROXY=<proxy-host>
MAC=<remote-mac>

log "Sending magic packet to $MAC"
ssh $PROXY etherwake -i eth0 $MAC

#!/usr/bin/env bash

log()   { printf "\033[1;34m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }
error() { printf "\033[1;31m[%s]\033[0m %s\n" "$(date '+%H:%M:%S')" "$*"; }

PROXY=
MAC=

ERRORED=0

if [ -z "$PROXY" ]; then
    error "proxy host is unset"
    ERRORED=1
fi

if [ -z "$MAC" ]; then
    error "remote interface mac unset"
    ERRORED=1
fi

if [ $ERRORED -eq 1 ]; then
    error "exiting with error"
    exit 1
fi

log "sending magic packet to $MAC"
ssh "$PROXY" etherwake -i eth0 "$MAC"

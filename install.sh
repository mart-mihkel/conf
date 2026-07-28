#!/usr/bin/env bash

set -euo pipefail

bash ./scripts/install-deps.sh
bash ./scripts/install-configs.sh
bash ./scripts/install-grub.sh

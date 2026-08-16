[doc('list recipes')]
[group('meta')]
[private]
@info:
    just --list

[doc('install dependencies and copy configs')]
[group('build')]
install:
    #!/usr/bin/env bash
    bash ./scripts/install-deps.sh
    bash ./scripts/install-configs.sh
    bash ./scripts/install-grub.sh

[doc('run pre-commit shellchecks')]
[group('lint')]
pre-commit:
    fdfind -e sh --exec shellcheck
    fdfind . bin --exec shellcheck

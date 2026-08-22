[doc('list recipes')]
[group('meta')]
[private]
@info:
    just --list

[doc('install dependencies and copy configs')]
[group('build')]
install:
    #!/usr/bin/env bash
    for script in ./scripts/install/*; do
        bash $script
    done

[doc('run pre-commit shellchecks')]
[group('lint')]
pre-commit:
    fdfind -e sh --exec shellcheck
    fdfind . bin --exec shellcheck

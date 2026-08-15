[doc('list recipes')]
[group('meta')]
[private]
@info:
    just --list

[doc('run pre-commit shellchecks')]
[group('lint')]
pre-commit:
	fdfind -e sh --exec shellcheck
	fdfind . bin --exec shellcheck

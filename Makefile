pre-commit:
	fdfind -e sh --exec shellcheck
	fdfind . bin --exec shellcheck

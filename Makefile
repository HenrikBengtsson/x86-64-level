all: shellcheck check

shellcheck:
	shellcheck x86-64-level
	shellcheck tests/x86-64-level.sh

check:
	@PATH=.:${PATH} tests/x86-64-level.sh

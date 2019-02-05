#!/bin/bash
# This script checks the code quality of the scripts in this directory.
# shell check must be installed on your $PATH to run this script.
# See https://github.com/koalaman/shellcheck for info
# See https://www.shellcheck.net for using an online editor for your snippets
# 

set -e
set -o pipefail

ERRORS=()

status=$(command -v shellcheck)
status=$?
if [ "1" == $status ]; then
	echo "FATAL: shellcheck is not installed, or is not found in your PATH"
	echo "	See https://github.com/koalaman/shellcheck#installing for installation options "
	exit 1
fi

# find all executables and run `shellcheck`
for f in $(find . -type f -not -iwholename '*.git*' | sort -u); do
	if file "$f" | grep --quiet shell; then
		{
			shellcheck "$f" && echo "[OK]: successfully linted $f"
		} || {
			# add to errors
			ERRORS+=("$f")
		}
	fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
	echo "No errors, hooray"
else
	echo "These files failed shellcheck: ${ERRORS[*]}"
	exit 1
fi

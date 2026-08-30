#!/bin/bash

set -o errexit -o nounset

if [ ! -d ./wiki ]; then
	git clone https://github.com/Steamodded/wiki wiki
fi

REV="$(./sync.sh)"

if [[ "$REV" == "$(cat stable/rev 2> /dev/null || echo '')" ]]; then
    echo "Already up to date"
    exit 0
fi

./script.sh

printf "$REV" > _tmpbuild/rev
printf "$(date)" > _tmpbuild/buildinfo


if [ -d "stable" ]; then
    rm -rf "stable"
fi

mv _tmpbuild stable

echo Built successfully, now in stable

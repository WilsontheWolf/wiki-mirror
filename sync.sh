#!/bin/bash

set -o errexit -o nounset

cd wiki

git fetch --quiet > /dev/null

git reset --hard origin/dev > /dev/null

git rev-parse --short HEAD

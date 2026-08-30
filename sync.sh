#!/bin/bash

set -o errexit -o nounset

cd wiki

git fetch --quiet > /dev/null

git pull > /dev/null

git rev-parse --short HEAD

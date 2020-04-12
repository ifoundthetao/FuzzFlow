#!/usr/bin/env bash
set -e
SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
FUZZFLOW_DIR=$(dirname "$SCRIPT_DIR")

cd "$FUZZFLOW_DIR"
[ -d "./fuzzdata" ] && mv fuzzdata fuzzdata.$$.$RANDOM
git clone https://github.com/moflow/fuzzdata

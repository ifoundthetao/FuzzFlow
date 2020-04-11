#!/usr/bin/env bash
set -e
SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
FUZZFLOW_DIR=$(dirname "$SCRIPT_DIR")

sudo apt-get install -y build-essential python-dev python-pip
sudo pip install virtualenv

virtualenv "${FUZZFLOW_DIR}/.env" --always-copy
source "${FUZZFLOW_DIR}/.env/bin/activate"
pip install -r "${FUZZFLOW_DIR}/scripts/requirements.txt"
deactivate

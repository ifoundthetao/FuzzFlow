#!/usr/bin/env bash
set -e
SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
FUZZFLOW_DIR=$(dirname "$SCRIPT_DIR")

sudo apt-get install -y build-essential python3-dev python3-pip python3-venv

env VIRTUALENV_ALWAYS_COPY=1 python3 -m venv "${FUZZFLOW_DIR}/.env"
source "${FUZZFLOW_DIR}/.env/bin/activate"
pip3 install -r "${FUZZFLOW_DIR}/scripts/requirements.txt"
deactivate

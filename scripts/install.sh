#!/usr/bin/env bash
set -e
SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

sudo apt-get install -y build-essential python-dev python-pip
sudo pip install virtualenv

if ! test -f .git/config && ! grep -q fuzzflow .git/config;  then 
	git clone https://github.com/moflow/FuzzFlow
	cd FuzzFlow
	FUZZFLOW_DIR=$(realpath "$PWD")
else
	FUZZFLOW_DIR=$(realpath "$PWD")
fi

echo $FUZZFLOW_DIR

#nginx nginx-extras uwsgi uwsgi-plugin-python
virtualenv "${FUZZFLOW_DIR}/.env" --always-copy
source "${FUZZFLOW_DIR}/.env/bin/activate"
pip install -r "${FUZZFLOW_DIR}/scripts/requirements.txt"
deactivate

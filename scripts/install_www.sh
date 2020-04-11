#!/bin/bash

set -e
SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
FUZZFLOW_DIR=$(dirname "${SCRIPT_DIR}")

sudo apt-get install -y build-essential python-dev python-pip nginx nginx-extras uwsgi uwsgi-plugin-python

cd "$SCRIPT_DIR"
sed -e "s#FUZZFLOW_WWW#${FUZZFLOW_DIR}/www#g" fuzzflow_nginx.conf | sudo tee /etc/nginx/sites-available/fuzzflow
sudo ln -sf /etc/nginx/sites-available/fuzzflow  /etc/nginx/sites-enabled/fuzzflow

sudo touch /tmp/fuzzflow.sock
sudo chown www-data:www-data /tmp/fuzzflow.sock

sed -e "s#FUZZFLOW_DIR#${FUZZFLOW_DIR}#g" fuzzflow_uwsgi.ini | sudo tee /etc/uwsgi/apps-available/fuzzflow.ini

sudo ln -sf /etc/uwsgi/apps-available/fuzzflow.ini /etc/uwsgi/apps-enabled/fuzzflow.ini

sudo chown -R www-data "$FUZZFLOW_DIR/www"
sudo chown www-data "$FUZZFLOW_DIR/fuzzsvc/app/moflow.db"

sudo service nginx restart
sudo service uwsgi restart

#!/bin/bash

SCRIPT_PATH="$0"
SCRIPT_DIR="$(dirname \"$SCRIPT_PATH\")"
FUZZFLOW_DIR="$(dirname \"$SCRIPT_DIR\")"

sudo apt-get install -y build-essential python-dev python-pip nginx nginx-extras uwsgi uwsgi-plugin-python

sed -i "s#FUZZFLOW_WWW#${FUZZFLOW_DIR}/www/frontend#g" nginx.conf
sudo cp fuzzflow_nginx.conf /etc/nginx/sites-available/fuzzflow
sudo ln -s /etc/nginx/sites-available/fuzzflow  /etc/nginx/sites-enabled/fuzzflow

touch /tmp/fuzzflow.sock
sudo chown www-data:www-data /tmp/fuzzflow.sock

sudo cat >>/etc/uwsgi/apps-available/fuzzflow.ini<<EOL
vhost = true
socket = /tmp/fuzzflow.sock
venv = "$FUZZFLOW_DIR/../.env"
chdir = "$FUZZFLOW_DIR/../"
module = server
callable = app
EOL

sudo ln -s /etc/uwsgi/apps-available/fuzzflow.ini /etc/uwsgi/apps-enabled/fuzzflow.ini

sudo service nginx restart
sudo service uwsgi restart

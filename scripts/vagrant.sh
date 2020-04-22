#!/usr/bin/env bash
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update
sudo apt-get install -y build-essential python-dev python-pip nginx nginx-extra uwsgi uwsgi-plugin-python
sudo pip install virtualenv
cd /vagrant
virtualenv .env --always-copy --no-site-packages
source .env/bin/activate
pip install -r requirements.txt
deactivate
touch /tmp/fuzzflow.sock
sudo chown www-data:www-data /tmp/fuzzflow.sock
sudo rm -rf /etc/nginx/sites-available/default
sudo cp /vagrant/nginx.conf /etc/nginx/sites-available/fuzzflow
sudo ln -s /etc/nginx/sites-available/fuzzflow  /etc/nginx/sites-enabled/fuzzflow
sudo cp /vagrant/uwsgi.ini /etc/uwsgi/apps-available/fuzzflow.ini
sudo ln -s /etc/uwsgi/apps-available/fuzzflow.ini /etc/uwsgi/apps-enabled/fuzzflow.ini
sudo service nginx restart
sudo service uwsgi restart

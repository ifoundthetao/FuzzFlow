#!/usr/bin/env bash
sudo apt-get install -y build-essential python-dev python-pip 
#nginx nginx-extras uwsgi uwsgi-plugin-python
sudo pip install virtualenv
virtualenv .env --always-copy
source .env/bin/activate
pip install -r requirements.txt
deactivate

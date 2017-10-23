#!/bin/bash
# Script to automate the installation of the CAM2 Camera API
# Author: Matthew Fitzgerald
echo This script will automatically install the CAM2 API to your development environment
echo 
echo This script is being ran by $USER on $HOSTNAME.
echo This script will only work of the above user is a member of the sudoers group.
read -p 'Type 1 if the user is a member of the sudoers group and you wish to continue: ' cont
if [ $cont = 1 ] 
then
    tput setaf 2; echo Continuing the Script!
    read -p 'Please type (or paste) the secret to the API here without quotes and press enter thwn finished: ' api

    tput setaf 4; echo Currently Updating Packages and Dependancies...
    tput setaf 7; sudo apt-get install -y git 

    tput setaf 4; echo Currently Cloning the most current version of the repository...
    tput setaf 7;  git clone https://github.com/PurdueCam2Project/CAM2Camera

    tput setaf 4; echo Currently Creating a Settings file...
    tput setaf 7; touch  CAM2Camera/API/settings_local.py
    echo '# Django settings for NetworkCamerasAPI project.' >> CAM2Camera/API/settings_local.py
    echo 'import os' >> CAM2Camera/API/settings_local.py
    echo 'print("""Imported Local Settings......""")' >> CAM2Camera/API/settings_local.py
    echo 'SECRET_KEY = "'"$api"'"' >> CAM2Camera/API/settings_local.py
    echo 'ALLOWED_HOSTS = ["'"*"'"]' >> CAM2Camera/API/settings_local.py
    echo 'SECURE_PROXY_SSL_HEADER = ("'"HTTP_X_FORWARDED_PROTO"'", "'"https"'")' >> CAM2Camera/API/settings_local.py
    echo 'BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))' >> CAM2Camera/API/settings_local.py
    echo 'STATIC_ROOT = "'"staticfiles"'"' >> CAM2Camera/API/settings_local.py
    echo 'STATIC_URL = ''"'"/static/"'"' >> CAM2Camera/API/settings_local.py
    echo 'STATIC_DIRS = (' >> CAM2Camera/API/settings_local.py
    echo '    os.path.join(BASE_DIR, "'"static"'"),' >> CAM2Camera/API/settings_local.py
    echo '    )' >> CAM2Camera/API/settings_local.py
    echo 'DATABASES = {' >> CAM2Camera/API/settings_local.py
    echo '    "'"default"'": {' >> CAM2Camera/API/settings_local.py
    echo '        "'"ENGINE"'": "'"django.contrib.gis.db.backends.postgis"'",' >> CAM2Camera/API/settings_local.py
    echo '        "'"NAME"'": "'"cam2api"'",' >> CAM2Camera/API/settings_local.py
    echo '        "'"USER"'": "'"cam2api"'",' >> CAM2Camera/API/settings_local.py
    echo '        "'"PASSWORD"'": "'"123456"'",' >> CAM2Camera/API/settings_local.py
    echo '        "'"HOST"'": "'"localhost"'",' >> CAM2Camera/API/settings_local.py
    echo '        "'"PORT"'": "'""'",' >> CAM2Camera/API/settings_local.py
    echo '    }' >> CAM2Camera/API/settings_local.py
    echo '}' >> CAM2Camera/API/settings_local.py
    echo 'DEBUG = True' >> CAM2Camera/API/settings_local.py

    tput setaf 4; echo Currently Installing API Dependancies...
    tput setaf 7; sudo apt-get install -y python-dev libpq-dev postgresql postgresql-contrib postgis python3-pip python3-venv

    tput setaf 4; echo Currently Configuring Database...
    tput setaf 7; sudo su - postgres
    psql
    CREATE DATABASE cam2api;
    CREATE USER cam2api WITH PASSWORD '123456';
    GRANT ALL PRIVILEGES ON DATABASE cam2api TO cam2api;
    \connect cam2api;
    CREATE EXTENSION postgis;
    \q
    exit

    tput setaf 4; echo Currently Creating Virtual Environment cam2apivenv...
    tput setaf 7; sudo su - postgres
    python3 –m venv cam2apivenv
    source cam2apivenv/bin/activate
    pip install --upgrade pip
    cd cam2api
    pip install –r requirements.txt

    tput setaf 4; echo Currently Starting Server...
    tput setaf 7; python manage.py makemigrations
    python manage.py migrate
    python manage.py runserver


else 
    echo Please rerun this script once you are a member of the sudoers group. 
fi
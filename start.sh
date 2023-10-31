#!/bin/bash

# Инициализация базы данных
service postgresql start
gosu postgres psql -c "CREATE USER myuser WITH PASSWORD 'mypassword';"
gosu postgres psql -c "CREATE DATABASE mydatabase OWNER myuser;"

# Запуск Gunicorn и Nginx
service nginx start
gunicorn djangoProject.wsgi:application --config /app/gunicorn_config.py

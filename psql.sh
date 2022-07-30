#!/bin/bash


dir=`realpath "$0"`
dir=`dirname "$dir"`

user=`grep '^POSTGRES_USER=' "${dir}/.env"`
user="${user#POSTGRES_USER=}"

dbname=`grep '^POSTGRES_DB=' "${dir}/.env"`
dbname="${dbname#POSTGRES_DB=}"

passwd=`grep '^POSTGRES_PASSWORD=' "${dir}/.env"`
passwd="${passwd#POSTGRES_PASSWORD=}"

docker-compose exec \
  postgres psql --user "${user}" --dbname "${dbname}" "$@"

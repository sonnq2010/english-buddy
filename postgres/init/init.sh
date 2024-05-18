#!/bin/bash
set -e

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE da2 ENCODING 'UTF8' TEMPLATE template0;
EOSQL

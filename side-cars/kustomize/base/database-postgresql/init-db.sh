#!/bin/bash
set -e
postgresqlSideCarDB=$(grep postgresqlSideCarDB= /tmp/annotations | awk -F = '{print $2}')
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE $postgresqlSideCarDB;
EOSQL

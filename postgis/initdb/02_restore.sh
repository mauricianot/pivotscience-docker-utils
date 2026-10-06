#!/bin/bash
set -e

echo "Starting database initialization..."

# --------------------------------------------------
# Create databases
# --------------------------------------------------

echo "Creating databases..."

psql -v ON_ERROR_STOP=1 \
  -U "$POSTGRES_USER" \
  -d postgres <<-EOSQL

CREATE DATABASE "$POSTGRES_DB_LSM";
CREATE DATABASE "$POSTGRES_DB_MRP";

EOSQL

# --------------------------------------------------
# Restore LSM
# --------------------------------------------------

echo "Restoring database: $POSTGRES_DB_LSM"

pg_restore \
  -v \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB_LSM" \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges \
  /docker-entrypoint-initdb.d/01_db_lsm.dump

# --------------------------------------------------
# Restore MRP
# --------------------------------------------------

echo "Restoring database: $POSTGRES_DB_MRP"

pg_restore \
  -v \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB_MRP" \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges \
  /docker-entrypoint-initdb.d/02_db_mrp.dump

echo "All database restores completed successfully."
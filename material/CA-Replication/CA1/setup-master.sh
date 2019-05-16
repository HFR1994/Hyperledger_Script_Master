#!/bin/bash

echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_user
      WHERE  username = $PG_REP_USER) THEN

      CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
   END IF;
END
EOSQL
cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = hot_standby
archive_mode = on
archive_command = 'cd .'
max_wal_senders = 8
wal_keep_segments = 8
hot_standby = on
EOF
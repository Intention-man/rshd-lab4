#!/bin/bash
# 1) Инициализируем БД (при первом старте)
if [ ! -s /var/lib/postgresql/data/PG_VERSION ]; then
  sudo -u postgres /usr/lib/postgresql/14/bin/initdb -D /var/lib/postgresql/data
fi
# 2) Настраиваем postgresql.conf
cat >> /var/lib/postgresql/data/postgresql.conf <<EOF
listen_addresses = '*'
wal_level = replica
max_wal_senders = 5
synchronous_standby_names = 'pg_sync'
synchronous_commit = on
EOF
# 3) Разрешаем подключения и репликацию
cat >> /var/lib/postgresql/data/pg_hba.conf <<EOF
host  replication  postgres  0.0.0.0/0  md5
host  all          all       0.0.0.0/0  md5
EOF
# 4) Запускаем postgres
exec sudo -u postgres /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/data

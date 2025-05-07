#!/bin/bash
ROLE=$(hostname)   # pg_sync или pg_async
PRIMARY_HOST="pg_primary"
# 1) Удаляем старые данные и делаем pg_basebackup
sudo -u postgres rm -rf /var/lib/postgresql/data/*
sudo -u postgres /usr/lib/postgresql/14/bin/pg_basebackup \
  -h ${PRIMARY_HOST} -D /var/lib/postgresql/data -U postgres -v -P --wal-method=stream
# 2) Создаём recovery.conf
cat > /var/lib/postgresql/data/recovery.conf <<EOF
standby_mode = 'on'
primary_conninfo = 'host=${PRIMARY_HOST} port=5432 user=postgres password=password'
trigger_file = '/tmp/promote_${ROLE}'
EOF
# 3) Запускаем standby
exec sudo -u postgres /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/data

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Установка PostgreSQL 14 в Ubuntu 24.04:
RUN apt-get update && \
    apt-get install -y wget gnupg && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg && \
    apt-get update && \
    apt-get install -y postgresql-14 postgresql-contrib-14 && \
    rm -rf /var/lib/apt/lists/*

COPY scripts /scripts
EXPOSE 5432
CMD ["bash","/scripts/init-primary.sh"]

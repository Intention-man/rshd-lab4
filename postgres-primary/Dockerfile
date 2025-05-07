FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y postgresql-14 postgresql-contrib-14 \
 && rm -rf /var/lib/apt/lists/*
COPY scripts /scripts
EXPOSE 5432
CMD ["bash","/scripts/init-primary.sh"]

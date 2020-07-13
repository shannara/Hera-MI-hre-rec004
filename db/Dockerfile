FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

# Install supervisord and OpenVPN client, and stuff for mongo https repository
RUN apt update && apt -y install wget gnupg apt-transport-https supervisor openvpn

# Install MongoDB 4.2
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
RUN echo "deb https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" \
    > /etc/apt/sources.list.d/mongodb-org-4.2.list && apt update -y \
    && apt -y install mongodb-org

# Add db.ovpn, supvervisor config
COPY db.ovpn /root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /data/db /data/configdb
VOLUME /data/db /data/configdb

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]

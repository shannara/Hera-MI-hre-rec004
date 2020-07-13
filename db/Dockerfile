FROM ubuntu:latest

# Install supervisord and OpenVPN client
RUN apt update && apt -y install mongodb supervisor openvpn

# Add db.ovpn, supvervisor config
COPY db.ovpn /root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /data/db /data/configdb
VOLUME /data/db /data/configdb

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]

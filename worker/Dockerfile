# Build
FROM ubuntu:latest AS builder
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Ensure image is up to date
RUN apt update && apt -y dist-upgrade

# Install stuff for build DCMTK from source and clean cache
RUN apt -y install build-essential cmake make libssl-dev libwrap0-dev libjpeg-dev \
    libpng-dev libxml2-dev libicu-dev libtiff-dev libopenjp2-7-dev libpng-dev git \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Get DCMTK source from github
RUN git clone https://github.com/DCMTK/dcmtk dcmtk-latest

# Build DCMTK (need build outside source)
RUN mkdir dcmtk-build && cd dcmtk-build && \
    cmake ../dcmtk-latest && \
    make && \
    make DESTDIR=$PWD/install install

# Runtime
FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root
COPY --from=builder /root/dcmtk-build/install/ /

# Ensure image is up to date
RUN apt update && apt -y dist-upgrade

# Add scripts
COPY scripts /root

# Set executable
RUN chmod +x /root/*_datas.sh

# Add private key for fetch datas from svc-node
RUN mkdir /root/.ssh
COPY ./hre.priv /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa
#RUN chown -R workuser. /root

# Install ssh client, python3 and pymongo and DCMTK runtime deps, supervisord
# and OpenVPN client. Finish by clean cache
RUN apt -y install openssh-client python3 python3-pymongo libicu66 supervisor \
    openvpn && apt clean && rm -rf /var/lib/apt/lists/*

# Add worker.ovpn, supvervisor config
COPY worker.ovpn /root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

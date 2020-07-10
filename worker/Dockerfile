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

COPY --from=builder /root/dcmtk-build/install/ /

# Ensure image is up to date
RUN apt update && apt -y dist-upgrade

# Create standard user
RUN useradd -m -s /bin/bash workuser

# Add scripts
COPY scripts /home/workuser/

# Set executable
RUN chmod +x /home/workuser/*_datas.sh

# Add private key for fetch datas from svc-node
RUN mkdir /home/workuser/.ssh
COPY ./hre.priv /home/workuser/.ssh/id_rsa
RUN chmod 700 /home/workuser/.ssh && chmod 600 /home/workuser/.ssh/id_rsa
RUN chown -R workuser. /home/workuser

# Install ssh client, python3 and pymongo and DCMTK runtime deps.
# Finish by clean cache
RUN apt -y install openssh-client python3 python3-pymongo libicu66 \
    && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /home/workuser
USER workuser

CMD ["/bin/bash"]

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

# Add script for fetch datas through scp from svc-node
COPY fetch_datas.sh /home/workuser/fetch_datas.sh
RUN chmod +x /home/workuser/fetch_datas.sh

# Add script to extract datas with dcmdump
COPY extract_datas.sh /home/workuser/extract_datas.sh
RUN chmod +x /home/workuser/extract_datas.sh

# Add private key for fetch datas from svc-node
RUN mkdir /home/workuser/.ssh
COPY ./hre.priv /home/workuser/.ssh/id_rsa
RUN chmod 700 /home/workuser/.ssh && chmod 600 /home/workuser/.ssh/id_rsa
RUN chown -R workuser. /home/workuser

# Install ssh client and DCMTK runtime deps.
# Finish by clean cache
RUN apt -y install openssh-client libicu66 && apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/workuser
USER workuser

CMD ["/bin/bash"]

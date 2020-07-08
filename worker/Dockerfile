FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

# Ensure image is up to date
RUN apt update && apt -y dist-upgrade

# Create standard user
RUN useradd -m -s /bin/bash workuser

# Add script for fetch datas through scp from svc-node
COPY fetch_datas.sh /home/workuser/fetch_datas.sh
RUN chmod +x /home/workuser/fetch_datas.sh

# Add private key for fetch datas from svc-node
RUN mkdir /home/workuser/.ssh /home/workuser/datas
COPY ./hre.priv /home/workuser/.ssh/id_rsa
RUN chmod 700 /home/workuser/.ssh && chmod 600 /home/workuser/.ssh/id_rsa
RUN chown -R workuser. /home/workuser

# Install ssh client
# Finish by clean cache
RUN apt -y install openssh-client && apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/workuser
USER workuser

CMD ["/bin/bash"]

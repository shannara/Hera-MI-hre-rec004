FROM centos:latest

# Ensure image is up-to-date
RUN dnf -y update

# Install stuff to serve files through SCP
RUN dnf -y install openssh-server git-core && dnf clean all

# Gen dummy keys, centos doesn't autogen them like ubuntu does
RUN /usr/bin/ssh-keygen -A

# Set SSH Configuration to allow remote logins without /proc write access
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

# Create filer user
RUN useradd -m -s /bin/bash filer

# Add public key for allow worker node to fetch files via SCP
RUN mkdir /home/filer/.ssh
COPY ./hre.pub /home/filer/.ssh/authorized_keys
RUN chmod 700 /home/filer/.ssh && chmod 600 /home/filer/.ssh/authorized_keys
RUN chown -R filer. /home/filer/.ssh

# Fetch files from github as filer
USER filer
RUN git clone https://github.com/hera-mi/test_material ~/test_material

# Go back to root
USER root

# Expose SSH port and run SSHD
# Remove /run/nologin (systemd not happy inside container)
EXPOSE 22
RUN rm -rf /run/nologin
CMD ["/usr/sbin/sshd", "-D"]

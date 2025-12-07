# --------------------------------------------------------------------------------
# Docker configuration for P4D
# --------------------------------------------------------------------------------

FROM ubuntu:focal

LABEL vendor="Personal"
LABEL maintainer="Marc Virgili"

# Update Ubuntu and add Perforce Package Source
RUN apt-get update && \
  apt-get install -y wget gnupg2 && \
  wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add - && \
  echo "deb http://package.perforce.com/apt/ubuntu focal release" > /etc/apt/sources.list.d/perforce.list && \
  apt-get update

# --------------------------------------------------------------------------------
# Docker BUILD
# --------------------------------------------------------------------------------

# Create perforce user and install Perforce Server
# Do in-page search over https://package.perforce.com/apt/ubuntu/dists/focal/release/binary-amd64/Packages
# for both "Package: helix-p4d" and "Package: helix-swarm-triggers".
RUN apt-get update && apt-get install -y helix-p4d=2025.2-2852709~focal helix-swarm-triggers=2025.1-2745343~focal
# Add external files
COPY files/restore.sh /usr/local/bin/restore.sh
COPY files/setup.sh /usr/local/bin/setup.sh
COPY files/init.sh /usr/local/bin/init.sh
COPY files/latest_checkpoint.sh /usr/local/bin/latest_checkpoint.sh
COPY files/run.sh /usr/local/bin/run.sh

RUN \
  chmod +x /usr/local/bin/restore.sh && \
  chmod +x /usr/local/bin/setup.sh && \
  chmod +x /usr/local/bin/init.sh && \
  chmod +x /usr/local/bin/latest_checkpoint.sh && \
  chmod +x /usr/local/bin/run.sh && \
  sed -i 's/\r$//' /usr/local/bin/restore.sh && \
  sed -i 's/\r$//' /usr/local/bin/setup.sh && \
  sed -i 's/\r$//' /usr/local/bin/init.sh && \
  sed -i 's/\r$//' /usr/local/bin/latest_checkpoint.sh && \
  sed -i 's/\r$//' /usr/local/bin/run.sh

# --------------------------------------------------------------------------------
# Docker ENVIRONMENT
# --------------------------------------------------------------------------------

# Default Environment
ARG NAME=perforce-server
ARG P4NAME=master
ARG P4TCP=1666
ARG P4USER=admin
ARG P4PASSWD=pass12349ers
ARG P4CASE=-C0
ARG P4CHARSET=utf8

# Dynamic Environment
ENV NAME=$NAME \
  P4NAME=$P4NAME \
  P4TCP=$P4TCP \
  P4PORT=$P4TCP \
  P4USER=$P4USER \
  P4PASSWD=$P4PASSWD \
  P4CASE=$P4CASE \
  P4CHARSET=$P4CHARSET \
  JNL_PREFIX=$P4NAME

# Base Environment
ENV P4HOME=/p4

# Derived Environment
ENV P4ROOT=$P4HOME/root \
  P4DEPOTS=$P4HOME/depots \
  P4CKP=$P4HOME/checkpoints

# Expose Perforce; TCP port and volumes
EXPOSE $P4TCP
VOLUME $P4HOME

# --------------------------------------------------------------------------------
# Docker RUN
# --------------------------------------------------------------------------------

# Use Exec form (JSON array)
ENTRYPOINT ["/usr/local/bin/run.sh"]

HEALTHCHECK \
  --interval=2m \
  --timeout=10s \
  CMD p4 info -s > /dev/null || exit 1

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    wget \
    nano \
    sudo \
    openssh-server \
    net-tools \
    iputils-ping \
    && mkdir -p /run/sshd

RUN echo "root:rootpass" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

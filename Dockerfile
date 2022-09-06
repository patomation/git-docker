FROM alpine:latest

LABEL MAINTAINER="Patrick Kelly patomation@gmail.com"

RUN apk update && apk upgrade
RUN apk add git
RUN apk add openrc
RUN apk add --update --no-cache openssh
RUN apk add -u awall

COPY ./awall-ssh.json /etc/awall/optional/ssh.json
RUN awall enable ssh

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

RUN git config --global init.defaultBranch main

# Enable sshd service at boot time
RUN rc-update add sshd

# Set up "git" user
# RUN adduser git --disabled-password --gecos ""
RUN adduser -h /home/git -s /bin/sh -D git
RUN echo -n 'git:password' | chpasswd

# Set up git folders
RUN su git
RUN cd
RUN mkdir .ssh && chmod 700 .ssh
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
RUN mkdir repos


EXPOSE 22
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

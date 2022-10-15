FROM alpine:latest

LABEL MAINTAINER="Patrick Kelly patomation@gmail.com"

ARG PASSWORD

RUN apk update && apk upgrade
RUN apk add git
RUN apk add openrc
RUN apk add --update --no-cache openssh

# AWALL Firewall
RUN apk add -u awall
COPY ./awall-ssh.json /etc/awall/optional/ssh.json
RUN awall enable ssh

# RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Make default branch names PC friendly and make warning go away
RUN git config --global init.defaultBranch main

# Enable sshd service at boot time
RUN rc-update add sshd

# Set up "git" user
# RUN adduser git --disabled-password --gecos ""
RUN adduser -h /home/git -s /bin/sh -D git
# Probably should change this password to something else
RUN echo -n "git:$PASSWORD" | chpasswd

# Set up git folders
RUN su git
RUN cd
RUN mkdir .ssh && chmod 700 .ssh
RUN touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
# NOTE: /home/git/repos and /repos are the same docker volume
# Make repo folder in home. USAGE: git remote add origin git@server/repos 
RUN mkdir /home/git/repos
# Make another repo folder in root.
# USAGE with different ssh port: git remote add origin ssh://git@server:2222/repos
# instead of having to do ssh://git@server:2222/home/git/repos
# We will be using docker volumes to have /home/git/repos and /repos be the same folder
RUN mkdir /repos
# let the "git" user be the owner. Just in case. Paranoia code
RUN chown git /repos

# Expose port 22 incase people don't use docker-compose
EXPOSE 22
# This entrypoint.sh keeps the server from stopping. There has to be a better way to do this
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

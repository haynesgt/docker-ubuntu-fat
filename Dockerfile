FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget neovim maven python2 python3 man-db gettext \
git build-essential unzip sudo openjdk-8-jdk openjdk-11-jdk

RUN yes | unminimize

RUN useradd ubuntu && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV NVM_DIR=/opt/nvm

RUN mkdir $NVM_DIR && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash \
&& . $NVM_DIR/nvm.sh && nvm install 12 && nvm install 14

RUN groupadd npm && usermod -aG npm ubuntu \
&& chown -R :npm /opt/nvm && chmod g+w -R /opt/nvm \
&& echo 'export NVM_DIR="/opt/nvm"' >> /etc/bash.bashrc \
&& echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/bash.bashrc \
&& echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/bash.bashrc

RUN . $NVM_DIR/nvm.sh && npm install -g express lodash

RUN echo 'export NODE_PATH=$(npm root -g)' >> /etc/bash.bashrc

RUN mkdir /home/ubuntu && chown ubuntu:ubuntu /home/ubuntu

WORKDIR /home/ubuntu

USER ubuntu

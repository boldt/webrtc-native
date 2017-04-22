FROM ubuntu:14.04.3

##############################################################################
# Replace shell with bash so we can source files
##############################################################################
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

##############################################################################
# Install dependencies from Ubuntu
##############################################################################

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing
RUN apt-get install -y curl build-essential libssl-dev

ENV NVM_DIR /usr/local/nvm
# Required by webrtc-native
ENV NODE_VERSION 5.8.0

##############################################################################
# Install nvm, node and npm
# http://stackoverflow.com/questions/25899912/install-nvm-in-docker
##############################################################################

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node --version
RUN npm --v

##############################################################################
# Copy Software
##############################################################################

RUN mkdir -p /opt/build
WORKDIR /opt/build
ADD . /opt/build

# Needed for msttcorefonts
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN apt-get update

##############################################################################
# Install dependencies for webrtc-native
##############################################################################

RUN ./install-build-deps.sh --no-prompt --no-chromeos-fonts

##############################################################################
# Build webrtc-native
##############################################################################

ENV BUILD_WEBRTC true
RUN npm --unsafe-perm install


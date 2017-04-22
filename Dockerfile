FROM boldt/base-ubuntu_14.04.3-node_5.8.0:0.0.2

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


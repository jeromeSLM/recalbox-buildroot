FROM ubuntu:16.04
MAINTAINER digitalLumberjack <digitallumberjack@recalbox.com>

ENV TERM xterm
ENV ARCH ''
ENV RECALBOX_VERSION_LABEL ''
ENV RECALBOX_UPDATE_MESSAGE ''

# Install dependencies
# needed ? xterm
RUN apt-get update -y && \
apt-get -y install build-essential git libncurses5-dev qt5-default qttools5-dev-tools \
mercurial libdbus-glib-1-dev texinfo zip openssh-client \
software-properties-common wget cpio bc locales rsync imagemagick \
nano vim automake mtools dosfstools subversion openjdk-8-jdk libssl-dev && \
rm -rf /var/lib/apt/lists/*

# Set the locale needed by toolchain
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN mkdir -p /work
WORKDIR /work

CMD echo "${RECALBOX_VERSION_LABEL}" > board/recalbox/fsoverlay/recalbox/recalbox.version && echo "${RECALBOX_UPDATE_MESSAGE}" > board/recalbox/fsoverlay/recalbox/recalbox.msg && make recalbox-${ARCH}_defconfig && sed -i "s|BR2_DL_DIR=.*|BR2_DL_DIR=\"/share/dl\"|g" .config && sed -i "s|BR2_HOST_DIR=.*\"|BR2_HOST_DIR=\"/share/host\"|g" .config && make -s

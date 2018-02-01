FROM resin/raspberrypi3-debian:stretch
ENV INITSYSTEM on

MAINTAINER J Hwang <code@johnvey.com>

# fetch the ssl and websockets deps because the Stretch repo isn't ready yet
RUN curl -O http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.0f-3+deb9u1_armhf.deb && \
    dpkg -i libssl1.1_1.1.0f-3+deb9u1_armhf.deb && \
    curl -O http://ftp.debian.org/debian/pool/main/libe/libev/libev4_4.22-1+b1_armhf.deb && \
    dpkg -i libev4_4.22-1+b1_armhf.deb && \
    curl -O http://ftp.debian.org/debian/pool/main/libu/libuv1/libuv1_1.9.1-3_armhf.deb && \
    dpkg -i libuv1_1.9.1-3_armhf.deb && \
    curl -O http://ftp.debian.org/debian/pool/main/libw/libwebsockets/libwebsockets8_2.0.3-2_armhf.deb && \
    dpkg -i libwebsockets8_2.0.3-2_armhf.deb

# install mosquitto server
RUN curl -O http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
    apt-key add mosquitto-repo.gpg.key && \
    curl -O /etc/apt/sources.list.d/mosquitto-stretch.list http://repo.mosquitto.org/debian/mosquitto-stretch.list && \
    apt-get update && \
    apt-get install -y mosquitto && \
    adduser --system --disabled-password --disabled-login mosquitto

# prep the data directories
RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log
COPY config /mqtt/config
RUN chown -R mosquitto /mqtt
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 8883 9001

ADD docker-entrypoint.sh /usr/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-v", "-c", "/mqtt/config/mosquitto.conf"]

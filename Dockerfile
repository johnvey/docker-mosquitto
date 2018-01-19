FROM resin/raspberrypi3-debian

MAINTAINER J Hwang <code@johnvey.com>


RUN apt-get update && \
    apt-get install -y wget

RUN wget http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.0f-3+deb9u1_armhf.deb && \
    dpkg -i libssl1.1_1.1.0f-3+deb9u1_armhf.deb && \
    wget http://ftp.debian.org/debian/pool/main/libe/libev/libev4_4.22-1+b1_armhf.deb && \
    dpkg -i libev4_4.22-1+b1_armhf.deb && \
    wget http://ftp.debian.org/debian/pool/main/libu/libuv1/libuv1_1.9.1-3_armhf.deb && \
    dpkg -i libuv1_1.9.1-3_armhf.deb && \
    wget http://ftp.debian.org/debian/pool/main/libw/libwebsockets/libwebsockets8_2.0.3-2_armhf.deb && \
    dpkg -i libwebsockets8_2.0.3-2_armhf.deb

RUN wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
    apt-key add mosquitto-repo.gpg.key && \
    wget -O /etc/apt/sources.list.d/mosquitto-stretch.list http://repo.mosquitto.org/debian/mosquitto-stretch.list && \
    apt-get update && \
    apt-get install -y mosquitto && \
    adduser --system --disabled-password --disabled-login mosquitto

RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log
COPY config /mqtt/config
RUN chown -R mosquitto:mosquitto /mqtt
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 9001

ADD docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]

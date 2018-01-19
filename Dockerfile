FROM resin/raspberrypi3-raspbian

MAINTAINER J Hwang <code@johnvey.com>

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

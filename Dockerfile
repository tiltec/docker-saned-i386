FROM i386/debian:stable
MAINTAINER Tilmann Becker <tilmann.becker@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && locale-gen en_US en_US.UTF-8 \
    && dpkg-reconfigure locales

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      sane \
      sane-utils \
      dbus \
      avahi-utils \
      runit \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# If the links below stop working, open http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and type in "3170"
ADD http://a1227.g.akamai.net/f/1227/40484/7d/download.ebz.epson.net/dsc/f/01/00/01/58/31/9d81f4deee448e0440c8bcd7af581c3e8a8b43b9/iscan-2.10.0-1.c2.i386.rpm \
    http://a1227.g.akamai.net/f/1227/40484/7d/download.ebz.epson.net/dsc/f/01/00/01/58/52/2da130fced78dc89c430122dc6111d69d182542b/iscan-plugin-gt-9400-1.0.0-1.c2.i386.rpm \
    /tmp/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      alien \
      libpangox-1.0-0 \
      libusb-0.1 \
    && alien -i /tmp/*.rpm \
    && apt-get remove -y alien \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser saned scanner \
    && adduser saned lp \
    && chown saned:lp /etc/sane.d/saned.conf /etc/sane.d/dll.conf

COPY services/ /etc/sv/
COPY runit_startup.sh /

RUN ln -s /etc/sv/dbus /etc/service/ \
    && ln -s /etc/sv/saned /etc/service/

EXPOSE 6566 10000 10001

CMD ["/runit_startup.sh"]

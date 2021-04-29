FROM registry.redhat.io/rhscl/devtoolset-10-toolchain-rhel7

ENV STUNNEL_VERSION 5.59

RUN yum update \
    && yum install wget \
    && wget -O - ftp://ftp.stunnel.org/stunnel/archive/4.x/stunnel-$STUNNEL_VERSION.tar.gz | tar -C /usr/local/src -zxv

RUN mkdir -p /stunnel
VOLUME ["/stunnel"]

# Build stunnel
RUN cd /usr/local/src/stunnel-$STUNNEL_VERSION && ./configure && make && make install

EXPOSE 443

CMD ["/usr/local/bin/stunnel", "/stunnel/stunnel.conf"]

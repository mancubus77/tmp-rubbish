FROM registry.redhat.io/rhscl/devtoolset-10-toolchain-rhel7
USER root
ENV STUNNEL_VERSION 5.59

# RUN yum update -y 
RUN yum install wget tar openssl-devel make -y \
    && wget -O - ftp://ftp.stunnel.org/stunnel/archive/5.x/stunnel-$STUNNEL_VERSION.tar.gz | tar -C /usr/local/src -zxv
    && mkdir -p /stunnel
VOLUME ["/stunnel"]

# Build stunnel
RUN cd /usr/local/src/stunnel-$STUNNEL_VERSION \
    && ./configure --disable-dependency-tracking \
    && make \
    && make install

EXPOSE 443
USER 1001
CMD ["/usr/local/bin/stunnel", "/stunnel/stunnel.conf"]

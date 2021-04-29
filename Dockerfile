FROM registry.redhat.io/rhscl/devtoolset-10-toolchain-rhel7
USER root
ENV STUNNEL_VERSION 5.59

RUN rm /etc/rhsm-host && \
    # Initialize /etc/yum.repos.d/redhat.repo
    # See https://access.redhat.com/solutions/1443553
    yum repolist --disablerepo=* && \
    subscription-manager repos --enable <enabled-repo> && \
    yum -y update && \
    yum -y install <rpms> && \
    # Remove entitlements and Subscription Manager configs
    rm -rf /etc/pki/entitlement && \
    rm -rf /etc/rhsm

RUN yum update \
    && yum install wget \
    && wget -O - ftp://ftp.stunnel.org/stunnel/archive/4.x/stunnel-$STUNNEL_VERSION.tar.gz | tar -C /usr/local/src -zxv

RUN mkdir -p /stunnel
VOLUME ["/stunnel"]

# Build stunnel
RUN cd /usr/local/src/stunnel-$STUNNEL_VERSION && ./configure && make && make install

EXPOSE 443

CMD ["/usr/local/bin/stunnel", "/stunnel/stunnel.conf"]

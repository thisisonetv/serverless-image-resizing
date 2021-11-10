FROM amazonlinux:latest

ADD etc/nodesource.gpg.key /etc

WORKDIR /tmp

RUN yum -y install gcc-c++ && \
    \
    rpm --import /etc/nodesource.gpg.key && \
    curl --location --output ns.rpm https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodejs-10.18.1-1nodesource.x86_64.rpm && \
    rpm --checksig ns.rpm && \
    rpm --install --force ns.rpm && \
    rm --force ns.rpm && \
    npm install -g npm@latest && \
    \
    amazon-linux-extras enable python3.8 && \
    yum install -y python3.8 && \
    ln -s /usr/bin/python3.8 /usr/bin/python3 && \
    \
    npm cache clean --force && \
    yum clean all

WORKDIR /build

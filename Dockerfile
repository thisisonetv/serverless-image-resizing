FROM amazonlinux:latest

WORKDIR /tmp

RUN yum -y install gcc-c++ make && \
    yum install https://rpm.nodesource.com/pub_18.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y && \
    yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 && \
    npm install -g npm@latest && \
    npm cache clean --force && \
    yum clean all

WORKDIR /build

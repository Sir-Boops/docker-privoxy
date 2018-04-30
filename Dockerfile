FROM alpine:3.7

ENV PRI_VER="3.0.26"

RUN addgroup privoxy && \
    adduser -H -D -G privoxy privoxy && \
    echo "privoxy:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk add -U --virtual deps \
        autoconf gcc g++ make \
        zlib-dev pcre-dev && \
    apk add pcre && \
    cd ~ && \
    wget --tries=10  https://downloads.sourceforge.net/ijbswa/privoxy-$PRI_VER-stable-src.tar.gz && \
    tar xf privoxy-$PRI_VER-stable-src.tar.gz && \
    cd ~/privoxy-$PRI_VER-stable && \
    autoheader && \
    autoconf && \
    ./configure --prefix=/opt/ --enable-compression && \
    make -j$(nproc) && \
    make install && \
    apk del --purge deps && \
    rm -rf ~/*

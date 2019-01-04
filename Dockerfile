FROM alpine:3.7

ENV PRI_VER="3.0.26"
ENV SHA_SUM="57e415b43ee5dfdca74685cc034053eaae962952fdabd086171551a86abf9cd8"

RUN apk add -U --virtual deps \
        autoconf gcc g++ make \
        zlib-dev pcre-dev && \
    apk add pcre && \
    cd ~ && \
    wget -O privoxy.tar.gz http://http.debian.net/debian/pool/main/p/privoxy/privoxy_$PRI_VER.orig.tar.gz && \
    echo "$SHA_SUM *privoxy.tar.gz" | sha256sum -c - && \
    tar xf privoxy.tar.gz && \
    cd ~/privoxy-$PRI_VER-stable && \
    autoheader && \
    autoconf && \
    ./configure --prefix=/opt/ --enable-compression && \
    make -j$(nproc) && \
    make install && \
    apk del --purge deps && \
    rm -rf ~/*

CMD /opt/sbin/privoxy --no-daemon --user privoxy.privoxy /opt/config

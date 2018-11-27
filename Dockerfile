FROM ubuntu:18.04 AS BUILD

#依赖环境
RUN apt-get -yqq update && \
        apt-get -y upgrade && \
        apt-get install -y \
        jq \
        git \
        gcc \
        g++ \
        make \
        cmake \
        python \
	autoconf \
        netcat \
        liblz4-dev \
        libssl-dev \
        libgss-dev \
        libkrb5-dev \
        librtmp-dev \
	libtool \
	librdkafka-dev \
        libidn11-dev \
        libsasl2-dev \
        libmpdec-dev \
        libldap2-dev \
        libgnutls28-dev \
        libalberta-dev \
        libjansson-dev \
        inetutils-ping \
        libmysqlclient-dev \
        libhttp-parser-dev \
        libcurl4-openssl-dev


RUN rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/edenhill/librdkafka.git && \
    cd librdkafka && ./configure && make && make install && \
    cd / && rm -rf librdkafka

RUN git clone https://github.com/paizzj/libev.git && \
    cd libev && ./configure && make && make install && \
    cd / && rm -rf libev

RUN git clone https://github.com/curl/curl.git \
	&& cd curl && ./buildconf \
	&& ./configure && make && make install

RUN cd /etc/ && echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig

WORKDIR /
RUN mkdir exchange_server

COPY depends exchange_server/depends
COPY network exchange_server/network
COPY utils   exchange_server/utils


COPY alertcenter exchange_server/alertcenter
COPY matchengine exchange_server/matchengine
COPY marketprice exchange_server/marketprice
COPY readhistory exchange_server/readhistory
COPY accesshttp  exchange_server/accesshttp
COPY accessws    exchange_server/accessws

COPY makefile.inc exchange_server/

# 编译
RUN cd exchange_server/depends/hiredis \
    && make \
    && mv libhiredis.* /usr/lib \
    && cd ../ && mv hiredis /usr/include

RUN cd exchange_server/network \
    && make

RUN cd exchange_server/utils \
    && make

RUN cd exchange_server/alertcenter \
    && make

RUN cd exchange_server/matchengine \
    && make

RUN cd exchange_server/marketprice \
    && make

RUN cd exchange_server/readhistory \
    && make

RUN cd exchange_server/accesshttp \
    && make

RUN cd exchange_server/accessws \
    && make

#RUN apt-get remove --purge -y \
#        jq \
#        git \
#        gcc \
#        g++ \
#        make \
#        cmake \
#        python \
#        netcat \
#        libev-dev \
#        libssl-dev \
#        libgss-dev \
#        libkrb5-dev \
#        librtmp-dev 
#        libidn11-dev \
#        libmpdec-dev \
#        libldap2-dev \
#        libgnutls-dev \
#        libalberta-dev \
#        libjansson-dev \
#        inetutils-ping \
#        libmysqlclient-dev \
#        libgttp-parser-dev \


# Multi-stage builds
FROM ubuntu:18.04

RUN apt-get -yqq update && \
    apt-get -y upgrade && \
    apt-get -y install \
    jq \
    git \
    autoconf \
    netcat \
    libtool \
    libgss3 \
    librtmp1 \
    librdkafka-dev \
    libldap-2.4-2 \
    libmysqlclient20 

RUN rm -rf /var/lib/apt/lists/*

#RUN git clone https://github.com/edenhill/librdkafka.git && \
#    cd librdkafka && ./configure && make && make install && \
#    cd / && rm -rf librdkafka

RUN git clone https://github.com/curl/curl.git \
	&& cd curl && ./buildconf \
	&& ./configure && make && make install
RUN mkdir /exchange_server
RUN mkdir -p /var/log/trade

COPY --from=BUILD   /exchange_server/alertcenter/alertcenter.exe \
                    /exchange_server/
COPY configs/alertcenter.json /exchange_server


COPY --from=BUILD   /exchange_server/matchengine/matchengine.exe \
                    /exchange_server/
COPY configs/matchengine.json /exchange_server


COPY --from=BUILD   /exchange_server/marketprice/marketprice.exe \
                    /exchange_server/
COPY configs/marketprice.json /exchange_server


COPY --from=BUILD   /exchange_server/readhistory/readhistory.exe \
                    /exchange_server/
COPY configs/readhistory.json /exchange_server


COPY --from=BUILD   /exchange_server/accesshttp/accesshttp.exe \
                    /exchange_server/
COPY configs/accesshttp.json /exchange_server


COPY --from=BUILD   /exchange_server/accessws/accessws.exe \
                    /exchange_server/
COPY configs/accessws.json /exchange_server

COPY entrypoint.sh /docker-entrypoint.sh

RUN cd /etc/ && echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig

ENTRYPOINT [ "/docker-entrypoint.sh" ]




#!/bin/bash

V="-v/var/log/mysql:/var/lib/mysql"

docker stop qb_mysql
docker rm qb_mysql
if [ -z $SH ];then
docker run --name=exchange_mysql $V $@ qb_mysql
else
docker run --name=exchange_mysql -it --entrypoint=/bin/sh $V $@ qb_mysql
fi

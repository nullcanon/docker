#!/bin/sh
WD=`dirname $0`
cd $WD && docker build -t qb_mysql1 .

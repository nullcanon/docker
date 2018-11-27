TARGET  := matchengine.exe
INCS = -I ../network -I ../utils -I ../depends
# LIBS = -L ../utils -lutils -L ../network -lnetwork -L ../depends/hiredis -Wl,-Bstatic -lev -ljansson -lmpdec -lrdkafka -lz -lssl -lcrypto -lhiredis -lcurl -Wl,-Bdynamic -lm -lpthread -ldl -llz4 -lssl -lmysqlclient

LIBS = -L ../utils -lutils -L ../network -lnetwork -L ../depends/hiredis -Wl,-Bstatic -lev -ljansson -lmpdec -lrdkafka -lz -lssl -lcrypto -lhiredis -lcurl -Wl,-Bdynamic -lm -lpthread -ldl -lssl -lldap -llber -lgss -lgnutls -lidn -lnettle -lrtmp -lsasl2 -lmysqlclient -llz4

include ../makefile.inc

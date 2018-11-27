TARGET  := accessws.exe
INCS = -I ../network -I ../utils

LIBS = -L ../utils -lutils -L ../network -lnetwork -Wl,-Bstatic -L ../lib -lev -ljansson -lmpdec -lz -lssl -lcrypto -lhiredis  -Wl,-Bdynamic      -lrdkafka -lcurl -lm -lpthread -ldl -llz4

include ../makefile.inc

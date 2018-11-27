TARGET  := marketprice.exe
INCS = -I ../network -I ../utils
LIBS = -L ../utils -lutils -L ../network -lnetwork -Wl,-Bstatic -L ../lib  -lev -ljansson -lmpdec -lz -llz4 -lssl -lcrypto -lhiredis -Wl,-Bdynamic -lrdkafka  -lm -lpthread -ldl -lcurl -lstdc++
include ../makefile.inc

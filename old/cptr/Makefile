NEKO_LIBS=${shell pkg-config --libs neko}
NEKO_CFLAGS=${shell pkg-config --cflags neko}

ALL_FLAGS=$(NEKO_LIBS) $(NEKO_CFLAGS)

MOD=../bin/cptr.ndll
LIB=../bin/libcptr.so
SRC=cptr.c

CC=gcc

default : $(MOD)

$(LIB) : $(SRC)
	$(CC) -shared -o $@ $(ALL_FLAGS) $<

$(MOD) : $(LIB)
	$(CC) -shared -o $@ $(ALL_FLAGS) -L../bin -lcptr

clean :
	-rm $(MOD) $(LIB)
	

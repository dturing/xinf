NEKO_MODULES=CPtr
RUN=CPtr
BINARIES+=cptr.ndll libcptr.so
include ../libraries.make

lib%.so : %.c
	gcc $(NEKO_CFLAGS) $(NEKO_LIBS) -shared -o $@ $<

cptr.ndll : libcptr.so
	ln -s $< $@

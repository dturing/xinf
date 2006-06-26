NEKO_MODULES=CPtr
RUN=CPtr
BINARIES+=cptr.ndll libcptr.so
SUBDIRS=GL GLU FT SDL X GdkPixbuf

include ../project.make

lib%.so : %.c
	gcc $(NEKO_CFLAGS) $(NEKO_LIBS) -shared -o $@ $<

cptr.ndll : libcptr.so
	ln -s $< $@

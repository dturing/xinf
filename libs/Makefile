GEN_MODS=GL GLU SDL FT GdkPixbuf X

NEKO_LIBS=${shell pkg-config --libs neko}
NEKO_CFLAGS=${shell pkg-config --cflags neko} -fPIC

cptr_LIBS=$(NEKO_LIBS)
cptr_CFLAGS=$(NEKO_CFLAGS)

TARGETS=libcptr.so cptr.ndll CPtr.hx ${foreach MOD,$(GEN_MODS),$(MOD).hx $(MOD)__.n $(MOD).ndll}

default : $(TARGETS)

# ------------------------------------------------------------
# building cptr helper lib

lib%.so : %.c
	gcc -shared -o $@ $($*_CFLAGS) $($*_LIBS) $< 

cptr.ndll : libcptr.so
	gcc -shared -o $@ $($*_CFLAGS) $($*_LIBS) $< 

# ------------------------------------------------------------
# copying actual modules

#.PHONY: subdirs

#subdirs: ${foreach MOD,$(GEN_MODS),$(MOD)/done}

%/done:
	$(MAKE) -C $*

%.hx: %/done
	cp $*/$*.hx .

%__.n: %/done
	cp $*/$*__.n .

%.ndll: %/done
	cp $*/$*.ndll .

# ------------------------------------------------------------
# just copy
%.hx : %.hx.in
	cp $< $@

clean :
	-rm $(wildcard *.n *__.hx *.hx *.ndll *.so)
	-rm $(wildcard */*.n */*__.hx */*.hx */*.ndll */*.so)

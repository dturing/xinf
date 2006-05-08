SUBDIRS = gst libs
HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp . -cp ./libs

HAXE_SRCS = $(shell find xinf xinfinity xinfony -name *.hx)

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr

sdl : cptr


default : subdirs test

bin/test.n : xinfony/Test.hx $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -neko $@ -main xinfony.Test
bin/test.js : xinfony/Test.hx $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -js $@ -main xinfony.Test
bin/test.swf : xinfony/Test.hx $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -fheader 320:240:25:ffffff -swf $@ -main xinfony.Test

test : subdirs bin/test.n bin/test.swf bin/test.js
	NEKOPATH=$(NEKOPATH):./libs:./gst neko bin/test.n

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
clean : 
	-rm Test.n
            

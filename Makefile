SUBDIRS = cptr gl sdl gst
HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp .

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr

sdl : cptr


default : subdirs test

Test.n : Test.hx
	haxe $(HAXEFLAGS) -neko Test.hx -main Test Test

test : Test.n subdirs
	neko Test.n

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
clean : 
	-rm Test.n
            

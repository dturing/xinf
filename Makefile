SUBDIRS = cptr gl sdl
HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp .

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr


default : test

Test.n : Test.hx
	haxe $(HAXEFLAGS) -neko Test.hx -main Test Test

test : Test.n subdirs
	neko Test.n

deepclean : 
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
clean : 
	-rm Test.n
            

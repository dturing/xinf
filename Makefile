SUBDIRS = gst libs
HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp . -cp ./libs

HAXE_SRCS = $(shell ls org/xinf/*.hx org/xinf/*/*.hx org/xinf/*/*/*.hx)

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr

sdl : cptr


default : subdirs test

Test.n : Test.hx $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -neko Test.hx -main Test Test

test : Test.n subdirs
	neko Test.n

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
clean : 
	-rm Test.n
            

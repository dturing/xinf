SUBDIRS = libs gst
HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp . -cp ./libs

HAXE_SRCS = $(shell find org -name *.hx)
MAIN_CLASS=org.xinf.ony.Test
MAIN_CLASS_FILE=org/xinf/ony/Test.hx

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr

sdl : cptr


default : subdirs test

bin/test.n : $(MAIN_CLASS_FILE) $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -neko $@ -main $(MAIN_CLASS)
bin/test.js : $(MAIN_CLASS_FILE) $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -js $@ -main $(MAIN_CLASS)
bin/test.swf : $(MAIN_CLASS_FILE) $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -fheader 320:240:25:ffffff -swf $@ -main $(MAIN_CLASS)

test : subdirs bin/test.n bin/test.swf bin/test.js
	NEKOPATH=$(NEKOPATH):./libs:./gst neko bin/test.n

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
            

SUBDIRS = libs gst
HAXEFLAGS=-cp . -cp ./libs
APP_HAXEFLAGS=-cp . -cp ../libs

HAXE_SRCS = $(shell find org -name *.hx)
MAIN_CLASS=org.xinf.Test
MAIN_CLASS_FILE=org/xinf/Test.hx

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr
sdl : cptr


default : subdirs xinfinity

bin/test.n : $(HAXE_SRCS) $(MAIN_CLASS_FILE)
	haxe $(HAXEFLAGS) -neko bin/test.n -main $(MAIN_CLASS) $(MAIN_CLASS)
bin/test.js : $(MAIN_CLASS_FILE) $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -js $@ -main $(MAIN_CLASS) 
bin/test.swf : $(MAIN_CLASS_FILE) $(HAXE_SRCS) assets.swfml $(shell find assets)
	swfmill simple assets.swfml assets.swf
	haxe $(HAXEFLAGS) -fheader 320:240:25:ffffff -swf-lib assets.swf -swf $@ -main $(MAIN_CLASS)

        
.PHONY: flash js xinfinity

flash: bin/test.swf
js: bin/test.js
xinfinity: bin/test.n

test : subdirs xinfinity
	NEKOPATH=$(NEKOPATH):./libs:./gst:./bin neko bin/test.n

bin/xtest.n : $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -neko bin/xtest.n -main org.xinf.x11.XForward
xtest : subdirs bin/xtest.n
	NEKOPATH=$(NEKOPATH):./libs:./gst:./bin neko bin/xtest.n

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
            

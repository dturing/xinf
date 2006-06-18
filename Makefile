SUBDIRS = libs gst
HAXEFLAGS=-cp . -cp ./libs
APP_HAXEFLAGS=-cp . -cp ../libs

HAXE_SRCS = $(shell find org -name *.hx)
TEST_CLASS=test.Test
TEST_CLASS_FILE=test/Test.hx

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

gl : cptr
sdl : cptr


default : subdirs xinfinity




test/run/test.n : $(HAXE_SRCS) $(TEST_CLASS_FILE)
	haxe $(HAXEFLAGS) -neko $@ -main $(TEST_CLASS)
test/run/test.js : $(TEST_CLASS_FILE) $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -js $@ -main $(TEST_CLASS) 
test/run/test.swf : $(TEST_CLASS_FILE) $(HAXE_SRCS) assets.swfml $(shell find assets)
	swfmill simple assets.swfml assets.swf
	haxe $(HAXEFLAGS) -swf-header 320:240:25:ffffff -swf-lib assets.swf -swf $@ -main $(TEST_CLASS)
test/TestServer.n : test/TestServer.hx
	haxe -neko test/TestServer.n -main test.TestServer
                
.PHONY: flash js xinfinity

swftest: test/run/test.swf
jstest: test/run/test.js
xinfinitytest: test/run/test.n

test : subdirs xinfinitytest jstest swftest test/TestServer.n
	test/runTests.sh


bin/adhoc.swf : $(HAXE_SRCS) assets.swfml $(shell find assets)
	swfmill simple assets.swfml assets.swf
	haxe $(HAXEFLAGS) -swf-header 320:240:25:ffffff -swf-lib assets.swf -swf $@ -main org.xinf.AdhocTest
bin/adhoc.js : $(TEST_CLASS_FILE) $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -js $@ -main org.xinf.AdhocTest
bin/adhoc.n : $(HAXE_SRCS)
	haxe $(HAXEFLAGS) -neko bin/adhoc.n -main org.xinf.AdhocTest
adhoc : subdirs bin/adhoc.n
	NEKOPATH=$(NEKOPATH):./libs:./gst:./bin neko bin/adhoc.n

bin/xtest.n : $(HAXE_SRCS) 
	haxe $(HAXEFLAGS) -neko bin/xtest.n -main org.xinf.x11.XinfTest 
xtest : subdirs bin/xtest.n 
	NEKOPATH=$(NEKOPATH):./libs:./gst:./bin neko bin/xtest.n 

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
            

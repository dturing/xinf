
SRC=$(wildcard xinf/*/*.hx xinf/*/*/*.hx)

INITYLIBSDIR=/home/dan/develop/xinf/libs
INITYLIBS=opengl xinfinity-support cptr
INITYCP=$(foreach LIB, $(INITYLIBS), -cp $(INITYLIBSDIR)/$(LIB)/api )
NEKOPATH:=$(NEKOPATH):$(subst : ,:,$(foreach LIB,$(INITYLIBS),$(INITYLIBSDIR)/$(LIB)/bin/Linux:$(INITYLIBSDIR)/$(LIB)/bin:))

HAXEFLAGS=--override $(INITYCP) -D htmltrace -cp ../../ -lib x11

TEST_DISPLAY=:10

default: test
	
testd : $(SRC)
	haxe $(HAXEFLAGS) -neko testserver.n -main xinf.test.TestServer;

# this ones a crazy target. use at your own risk
testenv : testd
	# kill running instances
	-pkill nekotools
	-pkill Xvfb

	# run server, might already be running. dont care.
	NEKOPATH=$NEKOPATH:/home/dan/.haxe/x11/0,0,0/ndll/Linux/ nekotools server &
	
	# run Xvfb, might also already be running and we dont care.
	Xvfb $(TEST_DISPLAY) -screen $(TEST_DISPLAY) 320x240x24 -fbdir /tmp -ac &
	
	# and the same for ratpoison
	DISPLAY=$(TEST_DISPLAY) ratpoison &
	DISPLAY=$(TEST_DISPLAY) xsetroot -solid red

test : $(SRC) testd
	haxe $(HAXEFLAGS) -neko test.n -main xinf.test.InteractiveTests;
	DISPLAY=$(TEST_DISPLAY) NEKOPATH=$(NEKOPATH) neko test.n

test-flash9 : $(SRC) testd
	-ps ax | grep "xinf test" | awk '{ print $$1; }'  | xargs kill
	haxe $(HAXEFLAGS) -swf test.swf -swf-header 320:240:25:000000 -swf-version 9 -main xinf.test.InteractiveTests;
	DISPLAY=$(TEST_DISPLAY) firefox -P "xinf test" -chrome "javascript:void(window.open('http://localhost:2000/static/test-flash.html','','chrome'))" &

test-js : $(SRC) testd
	-ps ax | grep "xinf test" | awk '{ print $$1; }'  | xargs kill
	haxe $(HAXEFLAGS) -js test.js -main xinf.test.InteractiveTests
	DISPLAY=$(TEST_DISPLAY) firefox -P "xinf test" -chrome "javascript:void(window.open('http://localhost:2000/static/test.html','','chrome'))" &
	
clean :
	-rm test.js test.n test.swf testserver.n results/*
	-rmdir results
	
SRC=$(wildcard xinf/*/*.hx xinf/*/*/*.hx)

INITYLIBS=cptr opengl xinfinity-support openvg
INITYCP=$(foreach LIB, $(INITYLIBS), -lib $(LIB) )
NEKOPATH:=$(NEKOPATH)

HAXEFLAGS=--override -D htmltrace -lib x11 -cp . -cp ../../ $(INITYCP)

TEST_DISPLAY=:10

default: test
	
testd : $(SRC)
	haxe $(HAXEFLAGS) -neko testserver.n -main xinf.test.TestServer;

# this ones a crazy target. use at your own risk
testenv : testd
	# kill running instances
	-pkill nekotools
	-pkill Xvfb

	# run server
	NEKOPATH=$(NEKOPATH):/home/dan/.haxe/x11/0,0,0/ndll/Linux/ nekotools server &
	
	# run Xvfb
	Xvfb $(TEST_DISPLAY) -screen $(TEST_DISPLAY) 481x361x24 -fbdir /tmp -ac &
	
	# and ratpoison
	DISPLAY=$(TEST_DISPLAY) ratpoison &

test : $(SRC) testd
	haxe $(HAXEFLAGS) -D notango -neko test.n -main xinf.test.svg.SVG12Testsuite;
	DISPLAY=$(TEST_DISPLAY) NEKOPATH=$(NEKOPATH) neko test.n

testa : $(SRC) testd
	haxe $(HAXEFLAGS) -D notango -neko test.n -main xinf.test.LoadSuite;
	DISPLAY=$(TEST_DISPLAY) NEKOPATH=$(NEKOPATH) neko test.n SVG1.2 metadata

test-flash9 : $(SRC) testd
	-ps ax | grep "xinf test" | awk '{ print $$1; }'  | xargs kill
	haxe $(HAXEFLAGS) -debug -swf test.swf -swf-header 480:360:25:ffffff -swf-version 9 -main xinf.test.svg.SVG12Testsuite;
	#DISPLAY=$(TEST_DISPLAY) firefox -P "xinf test" -chrome "javascript:void(window.open('http://localhost:2000/static/test-flash.html','','chrome'))" &
	#swfmill swf2xml test.swf stdout | swfmill xslt usenetwork.xslt - test2.swf
	flashplayer-dbg http://localhost:2000/test.swf

test-js : $(SRC) testd
	-ps ax | grep "xinf test" | awk '{ print $$1; }'  | xargs kill
	haxe $(HAXEFLAGS) -js test.js -main xinf.test.svg.SVG12Testsuite
	DISPLAY=$(TEST_DISPLAY) firefox -P "xinf test" -chrome "javascript:void(window.open('http://localhost:2000/static/test.html','','chrome'))" &
	
clean :
	-rm test.js test.n test.swf testserver.n results/*
	-rmdir results

INITYLIBS=cptr opengl openvg xinfinity-support
INITYCP=$(foreach LIB, $(INITYLIBS), -lib $(LIB) )

HAXEFLAGS=-D htmltrace -cp . -cp ../ $(INITYCP)

TEST_DISPLAY=:10

default: test
	
testd.n : $(SRC)
	haxe $(HAXEFLAGS) -neko testd.n -main testd.TestD;

# this ones a crazy target. use at your own risk
testenv : testd.n
	# kill running instances
	-pkill nekotools
	-pkill Xvfb

	# run Xvfb
	Xvfb $(TEST_DISPLAY) -screen $(TEST_DISPLAY) 481x361x24 -fbdir /tmp -ac &
	
	# and ratpoison
	DISPLAY=$(TEST_DISPLAY) ratpoison &

	# run server
	nekotools server &

.PHONY :
test : .PHONY
	haxe $(HAXEFLAGS) -D notango -neko test.n -main test.TestShell;
	DISPLAY=$(TEST_DISPLAY) NEKOPATH=$(NEKOPATH) neko test.n

flash : .PHONY
	haxe $(HAXEFLAGS) -D notango -debug -swf test.swf -swf-header 480:360:25:ffffff -swf-version 9 -main test.TestShell;
	DISPLAY=$(TEST_DISPLAY) firefox -P "xinf test" -chrome "javascript:void(window.open('http://localhost:2000/static/test-flash.html','','chrome'))" &

js : .PHONY
	haxe $(HAXEFLAGS) -D notango -js test.js -main test.TestShell;
	DISPLAY=$(TEST_DISPLAY) firefox -P "xinf test" -chrome "javascript:void(window.open('http://localhost:2000/static/test.html','','chrome'))" &

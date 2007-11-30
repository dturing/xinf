BINARY:=bin/nekobind
SRCS:=$(wildcard nekobind/*.hx nekobind/*/*.hx)

default: $(BINARY)

$(BINARY): $(SRCS)
	haxe -neko $(BINARY).n -main nekobind.App
	nekotools boot $(BINARY).n

.PHONY: test 

test: $(BINARY) test/Tester.hx Makefile
	haxe -neko test/tester-xml.n -xml test/tester.xml test.Tester
	# c binding
	$(BINARY) -c test/tester.xml test.Tester > test/bind_tester.c
	gcc -shared -fPIC -lneko -o test/tester.ndll test/bind_tester.c test/tester.c
	# haxe implementation in neko module
	$(BINARY) -i test/tester.xml test.Tester > test/Tester__impl.hx
	haxe -cp test/ -neko test/tester.n Tester__impl
	# build the test shell
	haxe -neko test/test.n -main test.App -lib cptr
	# run the test shell
	NEKOPATH=test/ neko test/test.n
	
clean:
	-@rm test/bind_tester* test/tester.n test/tester-xml.n test/tester.ndll test/tester.xml test/Tester__impl.hx $(BINARY) $(BINARY).n test/test.n

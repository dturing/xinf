#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=cptr

# platform default, set this to "Mac" or "Windows" (from the environment) for cross-compilation
NEKO_PLATFORM?=Linux

# project cflags and libs
PROJECT_CFLAGS:=
PROJECT_LIBS:=


## NO CHANGES BEYOND HERE (?)

BIN_PATH:=../bin
SRC_PATHS:=../src ../src/$(NEKO_PLATFORM)
NDLL:=$(BIN_PATH)/$(NEKO_PLATFORM)/$(PROJECT).ndll

PROJECT_CFLAGS+=$(foreach SRC_PATH, $(SRC_PATHS), -I$(SRC_PATH))
C_SRCS:=$(foreach SRC_PATH, $(SRC_PATHS), $(wildcard $(SRC_PATH)/*.c))
C_HEADERS:=$(foreach SRC_PATH, $(SRC_PATHS), $(wildcard $(SRC_PATH)/*.h))

ALL_FLAGS=$(NEKO_CFLAGS) $(NEKO_LIBS) $(PLATFORM_CFLAGS) $(PLATFORM_LIBS) $(PROJECT_CFLAGS) $(PROJECT_LIBS)


# setup cross-compilation (or not)

ifeq ($(NEKO_PLATFORM),Mac)
		PATH:=$(PATH):/opt/osx/bin
		OSX_SDK:=/opt/osx/MacOSX10.4u.sdk/
		NEKO_CFLAGS:=-I/opt/osx/manual/include -DNEKO_OSX
		NEKO_LIBS:=-dynamiclib -L/opt/osx/manual/lib -lneko
		PLATFORM_CFLAGS:=-I/opt/osx/powerpc-apple-darwin/include 
		PLATFORM_CFLAGS+=-isysroot $(OSX_SDK) -Wl,-syslibroot,$(OSX_SDK)

$(NDLL): $(NDLL).x86 $(NDLL).ppc
	i686-apple-darwin-lipo -create -output $@ -arch i386 $(NDLL).x86 -arch ppc $(NDLL).ppc

$(NDLL).x86: $(C_SRCS) $(C_HEADERS)
	i686-apple-darwin-gcc -o $@ $(C_SRCS) $(ALL_FLAGS)

$(NDLL).ppc: $(C_SRCS) $(C_HEADERS)
	powerpc-apple-darwin-gcc -o $@ $(C_SRCS) $(ALL_FLAGS)

else
	ifeq ($(NEKO_PLATFORM),Windows)
		CC:=mingw32-gcc
		NEKO_CFLAGS:=-I/opt/mingw/include -DNEKO_WIN
		NEKO_LIBS:=-shared -L/opt/mingw/lib -lneko
	else
		CC:=gcc
		NEKO_CFLAGS:=-fPIC -shared -DNEKO_LINUX
		NEKO_LIBS:=-L/usr/lib -lneko -lz  -ldl
	endif

$(NDLL): $(C_SRCS) $(C_HEADERS)
	$(CC) -o $@ $(C_SRCS) $(ALL_FLAGS)

endif



# meta-targets (not dependant on $(NEKO_PLATFORM)

all:
	NEKO_PLATFORM=Linux make
	NEKO_PLATFORM=Mac make
	NEKO_PLATFORM=Windows make
	
clean:
	-@rm $(BIN_PATH)/Mac/* $(BIN_PATH)/Windows/* $(BIN_PATH)/Linux/*


# build haxelib package

HAXELIB_ROOT:=../haxelib
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)
TEST_SAMPLE:=../samples/0-test

haxelib : $(HAXELIB_PROJECT).zip
	
$(HAXELIB_PROJECT).zip: all
	mkdir -p $(HAXELIB_PROJECT)
	
	-rm -rf $(HAXELIB_PROJECT)/bin $(HAXELIB_PROJECT)/$(PROJECT) $(HAXELIB_PROJECT)/samples $(HAXELIB_PROJECT).zip $(HAXELIB_PROJECT)/run.n
	
	# copy haxelib.xml
	cp ../haxelib.xml $(HAXELIB_PROJECT)
	
	# copy platform ndlls
	mkdir -p $(HAXELIB_PROJECT)/ndll/Linux
	cp ../bin/Linux/$(PROJECT).ndll $(HAXELIB_PROJECT)/ndll/Linux/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Mac
	cp ../bin/Mac/$(PROJECT).ndll $(HAXELIB_PROJECT)/ndll/Mac/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Windows
	cp ../bin/Windows/$(PROJECT).ndll $(HAXELIB_PROJECT)/ndll/Windows/
	
	# copy haXe API and Samples
	svn export ../api/$(PROJECT) $(HAXELIB_PROJECT)/$(PROJECT)
	svn export ../samples $(HAXELIB_PROJECT)/samples
	
	# package and test-install the haxelib once (we need it to compile the test)
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
	haxelib test $(HAXELIB_PROJECT).zip
	
	# build the "0-test" sample for haxelib run
	cd $(TEST_SAMPLE); haxe compile.hxml;
	cp $(TEST_SAMPLE)/run.n $(HAXELIB_PROJECT)/
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
	
test: haxelib
	haxelib test $(HAXELIB_PROJECT).zip
	haxelib run $(PROJECT)

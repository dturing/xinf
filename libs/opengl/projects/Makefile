#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=opengl
BINDING_CLASSES:=GL GLU GLUT Tesselator

# platform default, set this to "Mac" or "Windows" (from the environment) for cross-compilation
NEKO_PLATFORM?=Linux

# project cflags and libs

ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-framework GLUT -framework OpenGL -framework System
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lopengl32 -lglu32 -lglut32
	else
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lGL -lGLU -lglut
	endif
endif


####################################################
## NO CHANGES BEYOND HERE (?)

API_PATH:=../api
BIN_PATH:=../bin
SRC_PATHS:=../src ../src/$(NEKO_PLATFORM)
NDLL:=$(BIN_PATH)/$(NEKO_PLATFORM)/$(PROJECT).ndll

TARGETS:=$(NDLL)

PROJECT_CFLAGS+=$(foreach SRC_PATH, $(SRC_PATHS), -I$(SRC_PATH))
C_SRCS:=$(foreach SRC_PATH, $(SRC_PATHS), $(wildcard $(SRC_PATH)/*.c))
C_HEADERS:=$(foreach SRC_PATH, $(SRC_PATHS), $(wildcard $(SRC_PATH)/*.h))

# c sources are generated and compiled into the ndll
BINDING_C_SRCS:=$(foreach CLASS, $(BINDING_CLASSES), bind_$(CLASS).c)
C_SRCS+=$(BINDING_C_SRCS)

ifdef BINDING_CLASSES
	# add the implementation neko module to TARGETS
	TARGETS+=$(BIN_PATH)/$(PROJECT).n
endif


####################################################
# setup cross-compilation (or not)

ifeq ($(NEKO_PLATFORM),Mac)
		PATH:=$(PATH):/opt/osx/bin
		OSX_SDK:=/opt/osx/MacOSX10.4u.sdk/
		NEKO_CFLAGS:=-I/opt/osx/manual/include -DNEKO_OSX
		NEKO_LIBS:=-dynamiclib -L/opt/osx/manual/lib -lneko
		PLATFORM_CFLAGS:=-I/opt/osx/powerpc-apple-darwin/include 
		PLATFORM_CFLAGS+=-isysroot $(OSX_SDK) -Wl,-syslibroot,$(OSX_SDK)

default: $(TARGETS)

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

default: $(TARGETS)

$(NDLL): $(C_SRCS) $(C_HEADERS)
	$(CC) -o $@ $(C_SRCS) $(ALL_FLAGS)

endif




ALL_FLAGS=$(NEKO_CFLAGS) $(NEKO_LIBS) $(PLATFORM_CFLAGS) $(PLATFORM_LIBS) $(PROJECT_CFLAGS) $(PROJECT_LIBS)


####################################################
# nekobind binding generation

# rule to generate a c binding class with nekobind
bind_%.c : ../api/$(PROJECT)/%.hx $(PROJECT).xml
	nekobind -c $(PROJECT).xml $(PROJECT).$* > $@

# rule to generate a haxe implementation class with nekobind
%__impl.hx : ../api/$(PROJECT)/%.hx $(PROJECT).xml
	nekobind -i $(PROJECT).xml $(PROJECT).$* > $@


# the interface is defined in API_PATH/PROJECT/*.hx
BINDING_HX:=$(foreach CLASS, $(BINDING_CLASSES), $(API_PATH)/$(PROJECT)/$(CLASS).hx)

# we use haxe to generate a type .xml
$(PROJECT).xml $(PROJECT)-tmp.n: $(BINDING_HX)
	haxe -neko $(PROJECT)-tmp.n -xml $@ -cp $(API_PATH) $(foreach CLASS, $(BINDING_CLASSES), $(PROJECT).$(CLASS))


# haxe "implementation classes" (loading the neko module and implement the defined interface)
BINDING_HX_IMPL:=$(foreach CLASS, $(BINDING_CLASSES), $(CLASS)__impl.hx)


# the neko implementation module
$(BIN_PATH)/$(PROJECT).n: $(BINDING_HX_IMPL)
	haxe -neko $@ $(BINDING_HX_IMPL)




####################################################
# meta-targets (not dependant on $(NEKO_PLATFORM)

all:
	NEKO_PLATFORM=Linux make
	NEKO_PLATFORM=Mac make
	NEKO_PLATFORM=Windows make
	
clean:
	-@rm $(BIN_PATH)/Mac/* $(BIN_PATH)/Windows/* $(BIN_PATH)/Linux/*
	-@rm $(PROJECT)-tmp.n $(PROJECT).xml $(foreach CLASS,$(BINDING_CLASSES),bind_$(CLASS).c $(CLASS)__impl.hx)


####################################################
# build haxelib package

HAXELIB_ROOT:=../haxelib
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)
TEST_SAMPLE:=../samples/0-test

haxelib : $(HAXELIB_PROJECT).zip
	
$(HAXELIB_PROJECT).zip: all
	-rm -rf $(HAXELIB_ROOT)
	mkdir -p $(HAXELIB_PROJECT)
	
	# copy haxelib.xml
	cp ../haxelib.xml $(HAXELIB_PROJECT)
	
	# copy platform ndlls
	mkdir -p $(HAXELIB_PROJECT)/ndll/Linux
	cp ../bin/Linux/$(PROJECT).ndll $(HAXELIB_PROJECT)/ndll/Linux/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Mac
	cp ../bin/Mac/$(PROJECT).ndll $(HAXELIB_PROJECT)/ndll/Mac/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Windows
	cp ../bin/Windows/$(PROJECT).ndll $(HAXELIB_PROJECT)/ndll/Windows/
	
	# copy neko impl module
	-cp $(BIN_PATH)/$(PROJECT).n $(HAXELIB_PROJECT)/ndll/Linux/
	-cp $(BIN_PATH)/$(PROJECT).n $(HAXELIB_PROJECT)/ndll/Mac/
	-cp $(BIN_PATH)/$(PROJECT).n $(HAXELIB_PROJECT)/ndll/Windows/
	
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

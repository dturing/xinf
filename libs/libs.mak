#
# xinf libs Makefile include for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#


# platform default, set this to "Mac" or "Windows" (from the environment) for cross-compilation
NEKO_PLATFORM?=Linux



API_PATH:=api
BIN_PATH:=bin
SRC_PATHS:=src src/$(NEKO_PLATFORM)
NDLL:=$(BIN_PATH)/$(NEKO_PLATFORM)/$(PROJECT).ndll

TARGETS:=$(NDLL)
NEKO_PLATFORMS:=Linux Mac Windows

PROJECT_CFLAGS+=$(foreach SRC_PATH, $(SRC_PATHS), -I$(SRC_PATH))
C_SRCS:=$(foreach SRC_PATH, $(SRC_PATHS), $(wildcard $(SRC_PATH)/*.c))
C_HEADERS:=$(foreach SRC_PATH, $(SRC_PATHS), $(wildcard $(SRC_PATH)/*.h))

HX_SRCS:=$(wildcard $(API_PATH)/*.hx $(API_PATH)/*/*.hx $(API_PATH)/*/*/*.hx)

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
		NEKO_CFLAGS:=-I/opt/osx/manual/include/neko -DNEKO_OSX
		NEKO_LIBS:=-dynamiclib -L/opt/osx/manual/lib -lneko
		PLATFORM_CFLAGS:=-I/opt/osx/powerpc-apple-darwin/include -fshort-enums -fpack-struct -lSystemStubs
		PLATFORM_CFLAGS+=-isysroot $(OSX_SDK) -Wl,-syslibroot,$(OSX_SDK)

default: $(TARGETS)

$(NDLL): $(NDLL).x86 $(NDLL).ppc
	i686-apple-darwin-lipo -create -output $@ -arch i386 $(NDLL).x86 -arch ppc $(NDLL).ppc

$(NDLL).x86: $(C_SRCS) $(C_HEADERS)
	i686-apple-darwin-gcc -o $@ $(C_SRCS) $(OSX_X86_CFLAGS) $(ALL_FLAGS)

$(NDLL).ppc: $(C_SRCS) $(C_HEADERS)
	powerpc-apple-darwin-gcc -o $@ $(C_SRCS) $(OSX_PPC_CFLAGS) $(ALL_FLAGS)

else
	ifeq ($(NEKO_PLATFORM),Windows)
		CC:=mingw32-gcc
		NEKO_CFLAGS:=-I/opt/mingw/include -I/opt/mingw/include/neko -DNEKO_WIN
		NEKO_LIBS:=-shared /opt/mingw/lib/neko.dll
	else
		CC:=gcc
		NEKO_CFLAGS:=-fPIC -shared -I/usr/include/neko
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
bind_%.c : api/$(XINF_PKG_PATH)/%.hx $(PROJECT).xml
	nekobind -c $(PROJECT).xml $(XINF_PKG).$* > $@

# rule to generate a haxe implementation class with nekobind
%__impl.hx : api/$(XINF_PKG_PATH)/%.hx $(PROJECT).xml
	nekobind -i $(PROJECT).xml $(XINF_PKG).$* > $@


# the interface is defined in $(API_PATH)/$(XINF_PKG_PATH)/*.hx
BINDING_HX:=$(foreach CLASS, $(BINDING_CLASSES), $(API_PATH)/$(XINF_PKG_PATH)/$(CLASS).hx)

# we use haxe to generate a type .xml
$(PROJECT).xml $(PROJECT)-tmp.n: $(BINDING_HX)
	haxe $(HAXEFLAGS) -neko $(PROJECT)-tmp.n -xml $@ -cp $(API_PATH) $(foreach CLASS, $(BINDING_CLASSES), $(XINF_PKG).$(CLASS))


# haxe "implementation classes" (loading the neko module and implement the defined interface)
BINDING_HX_IMPL:=$(foreach CLASS, $(BINDING_CLASSES), $(CLASS)__impl.hx)


# the neko implementation module
$(BIN_PATH)/$(PROJECT).n: $(BINDING_HX_IMPL)
	haxe $(HAXEFLAGS) -cp api -neko $@ $(BINDING_HX_IMPL)



####################################################
# build haxelib package
HAXELIB_ROOT:=haxelib
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)

haxelib-test : haxelib
	haxelib test $(HAXELIB_PROJECT).zip

haxelib : $(HAXELIB_PROJECT).zip
		
$(HAXELIB_PROJECT).zip: $(NDLL) $(TARGETS) $(HX_SRCS)
	-rm -rf $(HAXELIB_ROOT)
	mkdir -p $(HAXELIB_PROJECT)
	
	# copy haxelib.xml
	cp haxelib.xml $(HAXELIB_PROJECT)
	
	# copy platform ndlls and .n modules
	mkdir $(HAXELIB_PROJECT)/ndll
#	-$(foreach PLATFORM, $(NEKO_PLATFORMS), mkdir $(HAXELIB_PROJECT)/ndll/$(PLATFORM); )
	svn --force export $(API_PATH) $(HAXELIB_PROJECT);
	-@rm $(BIN_PATH)/Mac/*.ppc; 
	-@rm $(BIN_PATH)/Mac/*.x86;
		-@$(foreach PLATFORM, $(NEKO_PLATFORMS), \
			svn export $(BIN_PATH)/$(PLATFORM) $(HAXELIB_PROJECT)/ndll/$(PLATFORM); \
			cp $(BIN_PATH)/$(PROJECT).n $(HAXELIB_PROJECT)/ndll/$(PLATFORM)/; \
			cp -r $(BIN_PATH)/$(PLATFORM)/*.ndll $(HAXELIB_PROJECT)/ndll/$(PLATFORM)/; \
		)
		-@cp $(BIN_PATH)/$(PROJECT).n $(HAXELIB_PROJECT)/ndll/$(PLATFORM)/; \
		#	cp $(BIN_PATH)/*.ttf $(HAXELIB_PROJECT)/ndll/; \
		#	cp $(BIN_PATH)/README $(HAXELIB_PROJECT)/ndll/; \
		#	cp -r $(BIN_PATH)/$(PLATFORM)/* $(HAXELIB_PROJECT)/ndll/$(PLATFORM)/; \
	
	# copy haXe API and Samples
	-@svn --force export test $(HAXELIB_PROJECT)/test
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)



####################################################
# meta-targets (not dependant on $(NEKO_PLATFORM)

all:
	NEKO_PLATFORM=Linux make
	NEKO_PLATFORM=Mac make
	NEKO_PLATFORM=Windows make
	
clean:
	-@rm $(BIN_PATH)/Mac/*.ndll $(BIN_PATH)/Windows/*.ndll $(BIN_PATH)/Linux/*.ndll
	-@rm $(BIN_PATH)/*.n $(BIN_PATH)/Mac/*.n $(BIN_PATH)/Windows/*.n $(BIN_PATH)/Linux/*.n
	-@rm $(PROJECT)-tmp.n $(PROJECT).xml $(foreach CLASS,$(BINDING_CLASSES),bind_$(CLASS).c $(CLASS)__impl.hx)

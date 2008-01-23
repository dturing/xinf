#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=xinfinity-gstreamer
XINF_PKG:=xinf
XINF_PKG_PATH:=xinf
BINDING_CLASSES:=

# project cflags and libs

ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:= \
			
		OSX_PPC_CFLAGS:= \
			
		OSX_X86_CFLAGS:= \
			
		PROJECT_LIBS:= \
		
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=
	else
		PROJECT_CFLAGS:=${shell pkg-config --cflags gstreamer-0.10 gstreamer-base-0.10} -O3 -march=pentium4 -fomit-frame-pointer
		PROJECT_LIBS:=${shell pkg-config --libs gstreamer-0.10 gstreamer-base-0.10}
	endif
endif


include ../libs.mak
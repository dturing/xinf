#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=cptr
BINDING_CLASSES:=
XINF_PKG:=cptr
XINF_PKG_PATH:=cptr


# project cflags and libs
ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=/opt/mingw/lib/neko.dll
	else
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=
	endif
endif


include ../libs.mak

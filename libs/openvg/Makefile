#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=openvg
BINDING_CLASSES:=Handle Path Paint VG VGU 
XINF_PKG:=openvg
XINF_PKG_PATH:=openvg


# project cflags and libs
ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:=-I/opt/osx/manual/include
		PROJECT_LIBS:=-framework OpenGL -framework System bin/Mac/libOpenVG.dylib -fno-common
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lopengl32 -lglu32 bin/Windows/libOpenVG.dll
	else
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lOpenVG -lGL -lGLU
	endif
endif


include ../libs.mak

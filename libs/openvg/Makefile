#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=openvg
BINDING_CLASSES:=VG VGU
XINF_PKG:=openvg
XINF_PKG_PATH:=openvg


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
		PROJECT_LIBS:=-lOpenVG
	endif
endif


include ../libs.mak

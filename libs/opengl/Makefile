#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=opengl
BINDING_CLASSES:=GL GLU GLUT
XINF_PKG:=opengl
XINF_PKG_PATH:=opengl


# project cflags and libs
ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-framework GLUT -framework OpenGL -framework System
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lopengl32 -lglu32 -L/opt/mingw/lib -lfreeglut
	else
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lGL -lGLU -lglut
	endif
endif


include ../libs.mak

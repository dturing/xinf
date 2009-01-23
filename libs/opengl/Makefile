#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=opengl
BINDING_CLASSES:=GL GLU GLFW Texture
XINF_PKG:=opengl
XINF_PKG_PATH:=opengl


# project cflags and libs
ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:=-I/opt/osx/manual/include
		PROJECT_LIBS:=-framework AGL -framework OpenGL -framework System bin/Mac/libglfw.dylib
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=
		PROJECT_LIBS:=-lopengl32 -lglu32 bin/Windows/glfw.dll
	else
		PROJECT_CFLAGS:=$(pkg-config --cflags libglfw)
		PROJECT_LIBS:=-lGL -lGLU -lglfw -lX11 -lXrandr -lXxf86vm
	endif
endif


include ../libs.mak

#
# haxelib Makefile for (cross-)compiling on linux
# the default target ("Linux" .ndll) should work on any gnu system
# cross-compilation depends on specific setup
# (osx environment in /opt/osx and gentoo crossdev mingw32)
#

# project name
PROJECT:=xinfinity-support
XINF_PKG:=xinf.support
XINF_PKG_PATH:=xinf/support
BINDING_CLASSES:=Pixbuf

# project cflags and libs

ifeq ($(NEKO_PLATFORM),Mac)
		PROJECT_CFLAGS:=-I/opt/osx/MacOSX10.4u.sdk/usr/X11R6/include/ -I/opt/osx/MacOSX10.4u.sdk/usr/X11R6/include/freetype2
		PROJECT_LIBS:=/opt/osx/MacOSX10.4u.sdk/usr/X11R6/lib/libfreetype.a
else
	ifeq ($(NEKO_PLATFORM),Windows)
		PROJECT_CFLAGS:=-I/opt/mingw/include -I/opt/mingw/include/freetype2 -I/opt/mingw/include/gtk-2.0 -I/opt/mingw/include/glib-2.0 -I/opt/mingw/lib/glib-2.0/include
		PROJECT_LIBS:=-lfreetype -lgobject-2.0 -lgdk_pixbuf-2.0
	else
		PROJECT_CFLAGS:=${shell freetype-config --cflags} ${shell pkg-config --cflags fontconfig} ${shell pkg-config --cflags gdk-pixbuf-2.0}
		PROJECT_LIBS:=${shell freetype-config --libs} ${shell pkg-config --libs fontconfig} ${shell pkg-config --libs gdk-pixbuf-2.0}
	endif
endif



include ../libs.mak
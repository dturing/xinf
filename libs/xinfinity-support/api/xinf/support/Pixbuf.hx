
package xinf.support;

/**
	Wraps GdkPixbuf structure.
	
	<nekobind 
		translator="CamelCaseToMinuscleUnderscore"
		prefix="gdk_pixbuf_"
		nekoAbstract="__pixbuf"
		cStruct="GdkPixbuf"
		dtor="unref"
		module="xinfinity-support"
		/>
	<nekobind:cHeader>
		#include &lt;gdk-pixbuf/gdk-pixbuf.h&gt;
		#include "neko-pixbuf.h"
	</nekobind:cHeader>
**/
extern class Pixbuf {
	public var width(getWidth,null):Int;
	public var height(getHeight,null):Int;
	
	public function getWidth():Int;
	public function getHeight():Int;
	public function getHasAlpha():Int;
	public function copyPixels():Dynamic;
	
	public function new() :Void;

	/** <nekobind ctor="true"/>	**/
	public static function newFromCompressedData( data:Dynamic ) :Pixbuf;
	
    public static function __init__() : Void {
        DLLLoader.addLibToPath("xinfinity-support");
        untyped {
            var loader = untyped __dollar__loader;
            Pixbuf = loader.loadmodule("xinfinity-support".__s,loader).Pixbuf__impl;
        }
    }
}

/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package gst;

class Object {
	private static var _get = neko.Lib.load("xinfinity-gstreamer","object_get",2);
	private static var _set = neko.Lib.load("xinfinity-gstreamer","object_set",3);

	public function new( o : Dynamic ) {
		untyped this.__o = o;
	}

	public function get( prop : String ) :Dynamic {
		return neko.Lib.nekoToHaxe( _get( untyped this.__o, neko.Lib.haxeToNeko(prop) ) );
	}
	
	public function set( prop : String, value : Dynamic ) : Void {
		return _set( untyped this.__o, neko.Lib.haxeToNeko(prop), value );
	}

	private static var _trigger_gc = neko.Lib.load("xinfinity-gstreamer","trigger_gc",0);
	public static function trigger_gc() :Bool {
		return _trigger_gc();
	}
}

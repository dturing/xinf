/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package gst;

class Buffer {
	private static var _data = neko.Lib.load("xinfinity-gstreamer","gst_buffer_data",1);
	private static var _size = neko.Lib.load("xinfinity-gstreamer","gst_buffer_size",1);
	private static var _caps = neko.Lib.load("xinfinity-gstreamer","gst_buffer_caps",1);
	private static var _free = neko.Lib.load("xinfinity-gstreamer","gst_buffer_free",1);
	
	private var _b:Dynamic;

	public function new( b : Dynamic ) {
		_b = b;
	}
	
	public function data() : Dynamic {
		return _data( _b );
	}

	public function size() :Int {
		return _size( _b );
	}

	public function caps() :Dynamic {
		return _caps( _b );
	}

	public function free() :Void {
		_free( _b );
		_b=null;
	}

	public function toString() :String {
		return("Buffer("+size()+")");
	}
}

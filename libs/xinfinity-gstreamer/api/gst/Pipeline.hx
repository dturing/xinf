/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package gst;

class Pipeline extends Object {

	private static var _launch = neko.Lib.load("xinfinity-gstreamer","parse_launch",1);
	public function new( launch:String ) {
		try {
			super( _launch(neko.Lib.haxeToNeko(launch)) );
		} catch( e:Dynamic ) {
			throw("Cannot launch pipeline '"+launch+"': "+e );
		}
	}
	
	private static var _find_child = neko.Lib.load("xinfinity-gstreamer","find_child",2);
	public function findChild( name:String ) : Object {
		var o:Dynamic = _find_child( untyped this.__o, neko.Lib.haxeToNeko(name) );
		if( !o ) return null;
		return new Object(o);
	}

	private static var _poll_bus = neko.Lib.load("xinfinity-gstreamer","poll_bus",2);
	public function pollBus( ?timeout:Int ) :GstBusMessage {
		var msg:GstBusMessage = _poll_bus( untyped this.__o, timeout );
		if( msg!=null && msg.type!=null ) {
			if( msg.name!=null ) msg.name = new String(msg.name);
			msg.type = new String(msg.type);
		}
		return msg;
	}

	public function pollAllBusMessages( f:GstBusMessage->Void ) :Void {
		var msg:GstBusMessage = pollBus(0);
		while( msg!=null ) {
			f(msg);
			msg = pollBus(0);
		}
	}

	private static var _query_position = neko.Lib.load("xinfinity-gstreamer","query_position",1);
	public function position() : Float {
		return _query_position( untyped this.__o );
	}
	private static var _query_duration = neko.Lib.load("xinfinity-gstreamer","query_duration",1);
	public function duration() : Float {
		return _query_duration( untyped this.__o );
	}

	private static var _seek = neko.Lib.load("xinfinity-gstreamer","seek",2);
	public function seek( to_time:Float ) : Bool {
		return _seek( untyped this.__o, to_time );
	}

	private static var _pause = neko.Lib.load("xinfinity-gstreamer","pipeline_pause",1);
	public function pause() : Bool {
		return _pause( untyped this.__o );
	}
	private static var _play = neko.Lib.load("xinfinity-gstreamer","pipeline_play",1);
	public function play() : Bool {
		return _play( untyped this.__o );
	}
}

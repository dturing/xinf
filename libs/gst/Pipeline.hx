package gst;

class Pipeline extends Object {

	private static var _launch = neko.Lib.load("GST","parse_launch",1);
	public function new( launch:String ) {
        super( _launch(launch) );
    }
    
	private static var _find_child = neko.Lib.load("GST","find_child",2);
    public function findChild( name:String ) : Object {
        var o:Dynamic = _find_child( untyped this.__o, name );
        if( !o ) return null;
        return new Object(o);
    }

	private static var _poll_bus = neko.Lib.load("GST","poll_bus",2);
    public function pollBus( ?timeout:Int ) : Dynamic {
		var m = _poll_bus( untyped this.__o, timeout );
		if( m != null ) {
			var name:String = "";
			untyped name.__s = m.name;
			m.name = name;
		}
		return m;
    }

	private static var _query_position = neko.Lib.load("GST","query_position",1);
    public function position() : Float {
		return _query_position( untyped this.__o );
    }
	private static var _query_duration = neko.Lib.load("GST","query_duration",1);
    public function duration() : Float {
		return _query_duration( untyped this.__o );
    }

	private static var _seek = neko.Lib.load("GST","seek",2);
    public function seek( to_time:Float ) : Bool {
		return _seek( untyped this.__o, to_time );
    }

	private static var _pause = neko.Lib.load("GST","pipeline_pause",1);
    public function pause() : Bool {
		return _pause( untyped this.__o );
    }
	private static var _play = neko.Lib.load("GST","pipeline_play",1);
    public function play() : Bool {
		return _play( untyped this.__o );
    }

	public static function main() :Void {
		var launch = "videotestsrc ! xvimagesink";
		trace("launch pipeline: "+launch );
		
		var pipeline = new Pipeline( launch );
		
		while( true ) {
			neko.Sys.sleep( 1 );
		}
	}
	
    public static function __init__() :Void {
		gst.Object._init();
    }
}

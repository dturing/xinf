package gst;

class Pipeline extends Object {
	private static var _launch = neko.Lib.load("GST","parse_launch",1);
	private static var _find_child = neko.Lib.load("GST","find_child",2);

    private var handoffElement:Dynamic;
    private var handoffBlocker:Dynamic;
    
    public function new( launch:String, ?handoffName:String ) {
        super( _launch(launch) );
    }
    
    public function findChild( name:String ) : Object {
        var o:Dynamic = _find_child( untyped this.__o, name );
        if( !o ) return null;
        return new Object(o);
    }

	private static var _poll_bus = neko.Lib.load("GST","poll_bus",2);
    public function pollBus( ?timeout:Int ) : Void {
		return _poll_bus( untyped this.__o, timeout );
    }

	public static function main() :Void {
		var launch = "videotestsrc ! xvimagesink";
		trace("launch pipeline: "+launch );
		
		gst.Object._init();
		var pipeline = new Pipeline( launch );
		
		while( true ) {
			neko.Sys.sleep( 1 );
		}
	}
}

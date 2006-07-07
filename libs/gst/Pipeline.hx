package gst;

class Pipeline extends Object {
	private static var _launch = neko.Lib.load("GST","parse_launch",1);
	private static var _find_child = neko.Lib.load("GST","find_child",2);

	private static var _register_handoff_blocker = neko.Lib.load("GST","register_handoff_blocker",1);
	private static var _handoff_block = neko.Lib.load("GST","handoff_block",1);
    
    private var handoffElement:Dynamic;
    private var handoffBlocker:Dynamic;
    
    public function new( launch:String, ?handoffName:String ) {
        super( _launch(launch) );
        
        handoffElement = null;
        handoffBlocker = null;
        
        if( handoffName != null ) {
            handoffElement = _find_child(untyped this.__o, handoffName);
            if( handoffElement != null ) {
                handoffBlocker = _register_handoff_blocker( handoffElement );
            }
        }
    }
    
    public function findChild( name:String ) : Object {
        var o:Dynamic = _find_child( untyped this.__o, name );
        if( !o ) return null;
        return new Object(o);
    }
    
    public function frame() : Dynamic {
        if( handoffBlocker != null ) {
            return new Buffer( _handoff_block( handoffBlocker ) );
        }
        return null;
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

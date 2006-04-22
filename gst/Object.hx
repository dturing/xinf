package gst;

class Object {
	private static var _inited = neko.Lib.load("GST","init",0)();
	private static var _get = neko.Lib.load("GST","object_get",2);
	private static var _set = neko.Lib.load("GST","object_set",3);

	private static var _ts = neko.Lib.load("GST","buffer_timestamp",1);

    public function new( o : Dynamic ) {
        untyped this.__o = o;
    }

    public function get( prop : String ) {
        return _get( untyped this.__o, untyped prop.__s );
    }
    
    public function set( prop : String, value : Dynamic ) : Void {
        return _set( untyped this.__o, untyped prop.__s, value );
    }
        
    public static function main() {
        trace("GObject test");
        
        var p:Pipeline = new Pipeline("videotestsrc pattern=snow ! overall name=o ! identity name=handoff ! fakesink","handoff");
        
        var o = p.findChild("o");
        
        while( true ) {
            var buf = p.frame();
            trace( "frame "+_ts(buf)+" "+o.get("value") );
            neko.Sys.sleep(.1);
        }
    }
}

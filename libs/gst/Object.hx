package gst;

class Object {
	private static var _get = neko.Lib.load("GST","object_get",2);
	private static var _set = neko.Lib.load("GST","object_set",3);

//	private static var _ts = neko.Lib.load("GST","buffer_timestamp",1);

    public function new( o : Dynamic ) {
        untyped this.__o = o;
    }

    public function get( prop : String ) :Dynamic {
        return _get( untyped this.__o, untyped prop.__s );
    }
    
    public function set( prop : String, value : Dynamic ) : Void {
        return _set( untyped this.__o, untyped prop.__s, value );
    }

	private static var _connect = neko.Lib.load("GST","object_connect",3);
    public function connect( signal:String, f:Dynamic ) : Void {
        return _connect( untyped this.__o, signal, f );
    }
	
	private static var _trigger_gc = neko.Lib.load("GST","trigger_gc",0);
	public static function trigger_gc() :Bool {
		return _trigger_gc();
	}
}

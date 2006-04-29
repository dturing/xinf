package gst;

class Object {
	public static var _init = neko.Lib.load("GST","_gst_init",0);
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
}

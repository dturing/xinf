package gst;

class Object {
	public static var _init = neko.Lib.load("GST","_gst_init",0);
	private static var _get = neko.Lib.load("GST","object_get",2);
	private static var _set = neko.Lib.load("GST","object_set",3);

	private static var _ts = neko.Lib.load("GST","buffer_timestamp",1);

    public function new( o : Dynamic ) {
        untyped this.__o = o;
    }

    public function get( prop : String ) :Dynamic {
        return _get( untyped this.__o, untyped prop.__s );
    }
    
    public function set( prop : String, value : Dynamic ) : Void {
        return _set( untyped this.__o, untyped prop.__s, value );
    }
	


/* this only works on gstgltexturesink! FIXME */
	private static var _lock_glmutex = neko.Lib.load("GST","lock_glmutex",1);
    public function lock() : Void {
        return _lock_glmutex( untyped this.__o );
    }
	private static var _unlock_glmutex = neko.Lib.load("GST","unlock_glmutex",1);
    public function unlock() : Void {
        return _unlock_glmutex( untyped this.__o );
    }
	
	private static var _wait_texture_available = neko.Lib.load("GST","wait_texture_available",1);
    public function wait_texture_available() : Void {
        return _wait_texture_available( untyped this.__o );
    }
	private static var _set_texture_consumed = neko.Lib.load("GST","set_texture_consumed",1);
    public function set_texture_consumed() : Void {
        return _set_texture_consumed( untyped this.__o );
    }
}

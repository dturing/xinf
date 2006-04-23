package gst;

class Buffer extends Object{

	private static var _ts = neko.Lib.load("GST","buffer_timestamp",1);
	private static var _analyze = neko.Lib.load("GST","analyze_buffer",1);

    public function new( o : Dynamic ) {
        super(o);
    }
    
    public function timestamp() : Int {
        return _ts( untyped this.__o );
    }
    
    public function analyze() : Dynamic {
        return _analyze( untyped this.__o );
    }
}

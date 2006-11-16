package gst;

class Buffer {
	private static var _data = neko.Lib.load("GST","gst_buffer_data",1);
	private static var _size = neko.Lib.load("GST","gst_buffer_size",1);
	
	private var _b:Dynamic = null;

    public function new( b : Dynamic ) {
		_b = b;
    }
    
    public function data() : Dynamic {
        return _data( _b );
    }

    public function size() :Int {
        return _size( _b );
    }

}

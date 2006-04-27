package org.xinf.util;

class DoublePointer {
    public property _ptr(default,null):Dynamic;
    private var _n : Int;

    public function new( n:Int ) {
        _n = n;
        _ptr = _alloc(_n);
    }
    
    public function set( n:Int, v:Float ) : Float {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _set( _ptr, n, v );
    }

    public function get( n:Int ) : Float {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _get( _ptr, n );
    }
    
    private static var _alloc = neko.Lib.load("cptr","cptr_double_alloc",1);
    private static var _set   = neko.Lib.load("cptr","cptr_double_set",3);
    private static var _get   = neko.Lib.load("cptr","cptr_double_get",2);
}

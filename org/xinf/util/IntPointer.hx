package org.xinf.util;

class IntPointer {
    public property _ptr(default,null):Dynamic;
    private var _n : Int;

    public function new( n:Int ) {
        _n = n;
        _ptr = _alloc(_n);
    }
    
    public function set( n:Int, v:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _set( _ptr, n, v );
    }

    public function get( n:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _get( _ptr, n );
    }

    public function array() : Array<Int> {
        // do this in C?
        var a:Array<Int> = new Array<Int>();        
        for( i in 0..._n ) {
            a[i] = _get( _ptr, i );
        }
        return a;
    }

    public function array_n( n:Int ) : Array<Int> {
        // do this in C?
        var a:Array<Int> = new Array<Int>();        
        for( i in 0...n ) {
            var v:Int = _get( _ptr, i );
            a[i] = v;
            trace( "intptr ["+i+"]: "+v );
        }
        return a;
    }

    private static var _alloc = neko.Lib.load("cptr","cptr_int_alloc",1);
    private static var _set   = neko.Lib.load("cptr","cptr_int_set",3);
    private static var _get   = neko.Lib.load("cptr","cptr_int_get",2);
}

class UIntPointer {
    public property _ptr(default,null):Dynamic;
    private var _n : Int;

    public function new( n:Int ) {
        _n = n;
        _ptr = _alloc(_n);
    }
    
    public function set( n:Int, v:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _set( _ptr, n, v );
    }

    public function get( n:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _get( _ptr, n );
    }

    public function array() : Array<Int> {
        // do this in C?
        var a:Array<Int> = new Array<Int>();        
        for( i in 0..._n ) {
            a[i] = _get( _ptr, i );
        }
        return a;
    }

    public function array_n( n:Int ) : Array<Int> {
        return _array_n( _ptr, n );
    }
/*
    public function array_n( n:Int ) : Array<Int> {
        // do this in C?
        var a:Array<Int> = new Array<Int>();        
        for( i in 0...n ) {
            var v:Int = _get( _ptr, i );
            a.push( v );
//            trace( "intptr ["+i+"]: "+v );
        }
        return a;
    }
*/

    private static var _alloc   = neko.Lib.load("cptr","cptr_unsigned_int_alloc",1);
    private static var _set     = neko.Lib.load("cptr","cptr_unsigned_int_set",3);
    private static var _get     = neko.Lib.load("cptr","cptr_unsigned_int_get",2);
    private static var _array_n = neko.Lib.load("cptr","cptr_unsigned_int_array_n",2);
}


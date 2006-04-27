package org.xinf.util;

class IntegerPointer {
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
    trace("Pointer get "+_ptr+" "+n+" -- "+Reflect.typeof(untyped this._get) );
        var r:Int = _get( _ptr, n );
    trace("Pointer get "+_ptr+" "+n+": "+r );
        return r;
    }

    public function array_n( n:Int ) : Array<Int> {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return _array_n(_ptr,n);
    }
    
    private function _alloc( n:Int ) : Dynamic {
    }
    private function _set( p:Dynamic, n:Int, v:Int ) : Int {
        return null;
    }
    private function _get( p:Dynamic, n:Int ) : Int {
        return null;
    }
    private function _array_n( p:Dynamic, n:Int ) : Array<Int> {
        return null;
    }
}

class IntPointer extends IntegerPointer {
    private static var __alloc   = neko.Lib.load("cptr","cptr_int_alloc",1);
    private static var __set     = neko.Lib.load("cptr","cptr_int_set",3);
    private static var __get     = neko.Lib.load("cptr","cptr_int_get",2);
    private static var __array_n = neko.Lib.load("cptr","cptr_int_array_n",2);
    
    private function _alloc( n:Int ) {
        return __alloc( n );
    }

    private function _set( p:Dynamic, n:Int, v:Int ) : Int {
        return __set( p, n, v );
    }

    private function _get( p:Dynamic, n:Int ) : Int {
        return __get( p, n );
    }

    private function _array_n( p:Dynamic, n:Int ) : Array<Int> {
        return __array_n( p, n );
    }
/*
    public function set( n:Int, v:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return f_set( _ptr, n, v );
    }
    private function _get( n:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
        return f_get( _ptr, n );
    }
    */
    static function main() {
        trace("informal IntPointer test");
        
        var p = new IntPointer(10);
        for( i in 0...9 ) {
            p.set( i, i*10 );
            trace("set "+i+" "+(i*10) );
        }
        for( i in 0...9 ) {
            var v = p.get( i );
            trace("["+i+"] "+v+" "+Reflect.typeof(v) );
        }
        
    }
}
/*
class UIntPointer extends Pointer<Int>{
    private static var f_alloc      = neko.Lib.load("cptr","cptr_unsigned_int_alloc",1);
    private static var f_set        = neko.Lib.load("cptr","cptr_unsigned_int_set",3);
    private static var f_get        = neko.Lib.load("cptr","cptr_unsigned_int_get",2);
    private static var f_array_n    = neko.Lib.load("cptr","cptr_unsigned_int_array_n",2);
    
    public function new( n:Int ) {
        super( n, f_alloc, f_set, f_get, f_array_n );
    }

    public function get_uint( n:Int ) : Int {
        if( n < 0 || n >= _n ) throw("index out of bounds");
    trace("UintPointer get "+_ptr+" "+n );
        var r:Int = f_get( _ptr, n );
    trace("/UintPointer get "+_ptr+" "+n );
        return r;
    }
}
*/

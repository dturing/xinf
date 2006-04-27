package org.xinf.util;

/*
    CPtr: Low-Level haXe access to C Pointers.
    
    BEWARE: playing with pointers is not for the faint of heart. there are little checks,
    so this interface helps you to shoot in your foot as good as you could with C.
    
    _alloc(sz) 
        returns a garbage-collected C pointer of the type and size specified.
        
    _set(p,i,v)             
        sets p[i] = v.
        
    _get(p,i)               
        gets p[i].
        
    _to_array(p,from,to)
        returns neko array of p[from..to].
        
    _from_array(p,from,values)
        sets p[from...] to (the neko array) values.
*/

class CPtr {
    public static var float_alloc      = neko.Lib.load("cptr","cptr_float_alloc",1);
    public static var float_set        = neko.Lib.load("cptr","cptr_float_set",3);
    public static var float_get        = neko.Lib.load("cptr","cptr_float_get",2);
    public static var float_to_array   = neko.Lib.load("cptr","cptr_float_to_array",3);
    public static var float_from_array = neko.Lib.load("cptr","cptr_float_from_array",3);

    public static var double_alloc      = neko.Lib.load("cptr","cptr_double_alloc",1);
    public static var double_set        = neko.Lib.load("cptr","cptr_double_set",3);
    public static var double_get        = neko.Lib.load("cptr","cptr_double_get",2);
    public static var double_to_array   = neko.Lib.load("cptr","cptr_double_to_array",3);
    public static var double_from_array = neko.Lib.load("cptr","cptr_double_from_array",3);

    public static var int_alloc      = neko.Lib.load("cptr","cptr_int_alloc",1);
    public static var int_set        = neko.Lib.load("cptr","cptr_int_set",3);
    public static var int_get        = neko.Lib.load("cptr","cptr_int_get",2);
    public static var int_to_array   = neko.Lib.load("cptr","cptr_int_to_array",3);
    public static var int_from_array = neko.Lib.load("cptr","cptr_int_from_array",3);

    public static var uint_alloc      = neko.Lib.load("cptr","cptr_unsigned_int_alloc",1);
    public static var uint_set        = neko.Lib.load("cptr","cptr_unsigned_int_set",3);
    public static var uint_get        = neko.Lib.load("cptr","cptr_unsigned_int_get",2);
    public static var uint_to_array   = neko.Lib.load("cptr","cptr_unsigned_int_to_array",3);
    public static var uint_from_array = neko.Lib.load("cptr","cptr_unsigned_int_from_array",3);
    
    public static var void_null = neko.Lib.load("cptr","cptr_void_null",0)();
    public static var void_cast = neko.Lib.load("cptr","cptr_void_cast",1);

    public static function main() {
        trace("informal cptr test");
        
        var n:Int = 10;
        var a:Array<Int> = new Array<Int>();
        
        var ptr = int_alloc(n);
        
        for( i in 0...n ) {
            int_set(ptr,i,i*10);
        }
        
        for( i in 0...n ) {
            if( int_get(ptr,i) != i*10 ) throw("get("+i+") failed");
        }
        
        var a2 = int_to_array(ptr,0,10);
        for( i in 0...n ) {
            if( a2[i] != i*10 ) throw("to_array()["+i+"] failed");
        }
        
        for( i in 0...n ) {
            a.push( i*100 );
        }
        int_from_array(ptr,0,untyped a.__a);
        for( i in 0...n ) {
            if( int_get(ptr,i) != i*100 ) throw("from_array()["+i+"] failed");
        }

        trace("tests passed.");        
    }
}

/*
    CPtr: Low-Level haXe access to C Pointers.
        
    do not modify "CPtr.hx", but "CPtr.hx.in".
    
    
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
/*
#if test
class TestCPtr extends haxe.unit.TestCase {
    function testInt() {
        var n:Int = 1024;
        var ptr = CPtr.int_alloc(n);
        
        for( i in 0...n ) {
            CPtr.int_set(ptr,i,i*10);
        }
        for( i in 0...n ) {
            assertEquals( i*10, CPtr.int_get(ptr,i) );
        }
    }

    function testUInt() {
        var n:Int = 1024;
        var ptr = CPtr.uint_alloc(n);
        
        for( i in 0...n ) {
            CPtr.uint_set(ptr,i,i*10);
        }
        for( i in 0...n ) {
            assertEquals( i*10, CPtr.uint_get(ptr,i) );
        }
    }

    function testShort() {
        var n:Int = 1024;
        var ptr = CPtr.short_alloc(n);
        
        for( i in 0...n ) {
            CPtr.short_set(ptr,i,i*10);
        }
        for( i in 0...n ) {
            assertEquals( i*10, CPtr.short_get(ptr,i) );
        }
    }

    function testUShort() {
        var n:Int = 1024;
        var ptr = CPtr.ushort_alloc(n);
        
        for( i in 0...n ) {
            CPtr.ushort_set(ptr,i,i*10);
        }
        for( i in 0...n ) {
            assertEquals( i*10, CPtr.ushort_get(ptr,i) );
        }
    }

    function testChar() {
        var n:Int = -128;
        var m:Int = 128;
        var ptr = CPtr.char_alloc(m-n);
        
        for( i in n...m ) {
            CPtr.char_set(ptr,i-n,i);
        }
        for( i in n...m ) {
            assertEquals( i, CPtr.char_get(ptr,i-n) );
        }
    }
    
    function testUChar() {
        var n:Int = 0;
        var m:Int = 255;
        var ptr = CPtr.uchar_alloc(m-n);
        
        for( i in n...m ) {
            CPtr.uchar_set(ptr,i-n,i);
        }
        for( i in n...m ) {
            assertEquals( i, CPtr.uchar_get(ptr,i-n) );
        }
    }
    
    function testFloat() {
        var n:Int = 1024;
        var ptr = CPtr.float_alloc(n);
        
        for( i in 0...n ) {
            CPtr.float_set(ptr,i,i*10);
        }
        for( i in 0...n ) {
            assertEquals( i*10, CPtr.float_get(ptr,i) );
        }
    }

    function testDouble() {
        var n:Int = 1024;
        var ptr:Dynamic = CPtr.double_alloc(n);
        
        for( i in 0...n ) {
            CPtr.double_set(ptr,i,i/10);
        }
        for( i in 0...n ) {
            assertEquals( i/10, CPtr.double_get(ptr,i) );
        }
    }
    
    function testIntFromArray() {
        var n:Int = 1024;
        var ptr:Dynamic = CPtr.int_alloc(n);
        var a = new Array<Int>();
        
        for( i in 0...n ) {
            a[i] = i*10;
        }
        CPtr.int_from_array( ptr, 0, untyped a.__a );
        for( i in 0...n ) {
            assertEquals( i*10, CPtr.int_get(ptr,i) );
        }
    }
    
    function testIntToArray() {
        var n:Int = 1024;
        var ptr:Dynamic = CPtr.int_alloc(n);
        var a:Array<Int>;
        
        for( i in 0...n ) {
            CPtr.int_set(ptr,i,i*10);
        }
        a = CPtr.int_to_array( ptr, 0, n );
        for( i in 0...n ) {
            assertEquals( i*10, a[i] );
        }
    }
   
    function testInvalidAssignment() {
        var ptr:Dynamic = CPtr.double_alloc(2);
        try {
            CPtr.double_set( ptr, 2, 1 );
        } catch( e:Dynamic ) {
            assertTrue( true );
            return;
        }
        assertTrue( false );
    }

    function testIndexOutOfBounds() {
        var ptr:Dynamic = CPtr.double_alloc(2);
        try {
            CPtr.double_set( ptr, 3, 1 );
        } catch( e:Dynamic ) {
            assertTrue( true );
            return;
        }
        try {
            CPtr.double_set( ptr, -1, 1 );
        } catch( e:Dynamic ) {
            assertTrue( true );
            return;
        }
        assertTrue( false );
    }

    function testCast() {
        var ptr:Dynamic = CPtr.uint_alloc(1);
        CPtr.uint_set( ptr, 0, 0xffffffff );
        
        for( i in 0...4 ) {
            assertEquals( 0xff, CPtr.uchar_get(ptr,i) );
        }
    }

    function testAsString() {
        var ptr:Dynamic = CPtr.short_alloc(2);
        CPtr.short_set( ptr, 0, 0x4241 );
        CPtr.short_set( ptr, 1, 0x4443 );
        
        assertEquals( untyped "ABCD".__s, CPtr.as_string(ptr) );
    }

    function testFromString() {
        var ptr:Dynamic = CPtr.from_string(untyped "ABCD".__s);
        
        assertEquals( 0x4241, CPtr.short_get(ptr,0) );
        assertEquals( 0x4443, CPtr.short_get(ptr,1) );
    }

	function testVoidNull() {
		var info:{ size:Int, address:Float } = untyped CPtr.info( CPtr.void_null );
		assertEquals( 0, info.size );
		assertEquals( 0., info.address );
	}
}

#end // test
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

    public static var uint_alloc      = neko.Lib.load("cptr","cptr_uint_alloc",1);
    public static var uint_set        = neko.Lib.load("cptr","cptr_uint_set",3);
    public static var uint_get        = neko.Lib.load("cptr","cptr_uint_get",2);
    public static var uint_to_array   = neko.Lib.load("cptr","cptr_uint_to_array",3);
    public static var uint_from_array = neko.Lib.load("cptr","cptr_uint_from_array",3);

    public static var char_alloc      = neko.Lib.load("cptr","cptr_char_alloc",1);
    public static var char_set        = neko.Lib.load("cptr","cptr_char_set",3);
    public static var char_get        = neko.Lib.load("cptr","cptr_char_get",2);
    public static var char_to_array   = neko.Lib.load("cptr","cptr_char_to_array",3);
    public static var char_from_array = neko.Lib.load("cptr","cptr_char_from_array",3);

    public static var uchar_alloc      = neko.Lib.load("cptr","cptr_uchar_alloc",1);
    public static var uchar_set        = neko.Lib.load("cptr","cptr_uchar_set",3);
    public static var uchar_get        = neko.Lib.load("cptr","cptr_uchar_get",2);
    public static var uchar_to_array   = neko.Lib.load("cptr","cptr_uchar_to_array",3);
    public static var uchar_from_array = neko.Lib.load("cptr","cptr_uchar_from_array",3);

    public static var short_alloc      = neko.Lib.load("cptr","cptr_short_alloc",1);
    public static var short_set        = neko.Lib.load("cptr","cptr_short_set",3);
    public static var short_get        = neko.Lib.load("cptr","cptr_short_get",2);
    public static var short_to_array   = neko.Lib.load("cptr","cptr_short_to_array",3);
    public static var short_from_array = neko.Lib.load("cptr","cptr_short_from_array",3);

    public static var ushort_alloc      = neko.Lib.load("cptr","cptr_ushort_alloc",1);
    public static var ushort_set        = neko.Lib.load("cptr","cptr_ushort_set",3);
    public static var ushort_get        = neko.Lib.load("cptr","cptr_ushort_get",2);
    public static var ushort_to_array   = neko.Lib.load("cptr","cptr_ushort_to_array",3);
    public static var ushort_from_array = neko.Lib.load("cptr","cptr_ushort_from_array",3);

    public static var void_null = neko.Lib.load("cptr","cptr_void_null",0)();
    public static var as_string = neko.Lib.load("cptr","cptr_as_string",1);
    public static var from_string = neko.Lib.load("cptr","cptr_from_string",1);
    public static var info = neko.Lib.load("cptr","cptr_info",1);
    #if test
        public static function main() {
    
                var r = new haxe.unit.TestRunner();
//                r.add( new TestCPtr() );
                r.run();
				
        }
    #end
}

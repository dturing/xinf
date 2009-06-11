/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
/*
	CPtr: Low-Level haXe access to C Pointers.
	
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

package cptr;

class CPtr {
	public static var float_alloc		= neko.Lib.load("cptr","cptr_float_alloc",1);
	public static var float_set			= neko.Lib.load("cptr","cptr_float_set",3);
	public static var float_get			= neko.Lib.load("cptr","cptr_float_get",2);
	public static var float_to_array	= neko.Lib.load("cptr","cptr_float_to_array",3);
	public static var float_from_array	= neko.Lib.load("cptr","cptr_float_from_array",2);
	
	public static var double_alloc		= neko.Lib.load("cptr","cptr_double_alloc",1);
	public static var double_set		= neko.Lib.load("cptr","cptr_double_set",3);
	public static var double_get		= neko.Lib.load("cptr","cptr_double_get",2);
	public static var double_to_array	= neko.Lib.load("cptr","cptr_double_to_array",3);
	public static var double_from_array	= neko.Lib.load("cptr","cptr_double_from_array",2);

	public static var int_alloc			= neko.Lib.load("cptr","cptr_int_alloc",1);
	public static var int_set			= neko.Lib.load("cptr","cptr_int_set",3);
	public static var int_get			= neko.Lib.load("cptr","cptr_int_get",2);
	public static var int_to_array		= neko.Lib.load("cptr","cptr_int_to_array",3);
	public static var int_from_array	= neko.Lib.load("cptr","cptr_int_from_array",2);

	public static var uint_alloc		= neko.Lib.load("cptr","cptr_uint_alloc",1);
	public static var uint_set			= neko.Lib.load("cptr","cptr_uint_set",3);
	public static var uint_get			= neko.Lib.load("cptr","cptr_uint_get",2);
	public static var uint_to_array		= neko.Lib.load("cptr","cptr_uint_to_array",3);
	public static var uint_from_array	= neko.Lib.load("cptr","cptr_uint_from_array",2);

	public static var char_alloc		= neko.Lib.load("cptr","cptr_char_alloc",1);
	public static var char_set			= neko.Lib.load("cptr","cptr_char_set",3);
	public static var char_get			= neko.Lib.load("cptr","cptr_char_get",2);
	public static var char_to_array		= neko.Lib.load("cptr","cptr_char_to_array",3);
	public static var char_from_array	= neko.Lib.load("cptr","cptr_char_from_array",2);

	public static var uchar_alloc		= neko.Lib.load("cptr","cptr_uchar_alloc",1);
	public static var uchar_set			= neko.Lib.load("cptr","cptr_uchar_set",3);
	public static var uchar_get			= neko.Lib.load("cptr","cptr_uchar_get",2);
	public static var uchar_to_array	= neko.Lib.load("cptr","cptr_uchar_to_array",3);
	public static var uchar_from_array	= neko.Lib.load("cptr","cptr_uchar_from_array",2);

	public static var short_alloc		= neko.Lib.load("cptr","cptr_short_alloc",1);
	public static var short_set			= neko.Lib.load("cptr","cptr_short_set",3);
	public static var short_get			= neko.Lib.load("cptr","cptr_short_get",2);
	public static var short_to_array	= neko.Lib.load("cptr","cptr_short_to_array",3);
	public static var short_from_array	= neko.Lib.load("cptr","cptr_short_from_array",2);

	public static var ushort_alloc		= neko.Lib.load("cptr","cptr_ushort_alloc",1);
	public static var ushort_set		= neko.Lib.load("cptr","cptr_ushort_set",3);
	public static var ushort_get		= neko.Lib.load("cptr","cptr_ushort_get",2);
	public static var ushort_to_array	= neko.Lib.load("cptr","cptr_ushort_to_array",3);
	public static var ushort_from_array	= neko.Lib.load("cptr","cptr_ushort_from_array",2);

	public static var zero				= neko.Lib.load("cptr","cptr_zero",1);
	public static var fill				= neko.Lib.load("cptr","cptr_fill",2);
	public static var copy				= neko.Lib.load("cptr","cptr_copy",5);

/*
	public static var void_null = neko.Lib.load("cptr","cptr_void_null",0)();
*/
}

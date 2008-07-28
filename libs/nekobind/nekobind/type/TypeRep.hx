/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package nekobind.type;
import haxe.rtti.CType;

class VoidType extends TypeRep {
	public function new() :Void {
		super(null,"Void","void");
	}
	override public function cReturn( c:String ) :String {
		return( c+"; return val_null;" );
	}
}

class UnknownType extends TypeRep {
	public function new() :Void {
		super(null,"Dynamic","void*");
	}
}

class NumericType extends TypeRep {
	public function new( n, hx, c ) :Void {
		super(n,hx,c);
	}
// "number" for everything...
	override public function asNeko() :String {
		return "number";
	}
	// ...except alloc_
	override public function cNekoAlloc( c:String ) :String {
		return( "alloc_"+nekoRep+"( "+c+" )" );
	}
}


class StringType extends TypeRep {
	public function new() :Void {
		super("string","String","const char*");
	}

	override public function cCheckAssign( c:String, n:String ) :String {
		return(
				"if( val_is_object("+n+") ) "
				+n+" = val_field("+n+",val_id(\"__s\")); "
				+super.cCheckAssign( c, n ) );
	}
	override public function cNekoAlloc( c:String ) :String {
		return( "alloc_"+nekoRep+"( (const char *)"+c+" )" );
	}
}


class FriendClassType extends TypeRep {
	var className:String;
	var cStruct:String;
	var primitive:String;
	public function new( className:String, cStruct:String, primitive:String ) :Void {
		this.className = className.split(".").pop();
		this.cStruct = cStruct;
		this.primitive = primitive;
		super("abstract",className,cStruct);
	}

	override public function cCheckAssign( c:String, n:String ) :String {
		return(
				n+" = val_field( "+n+", val_id(\""+primitive+"\") );"
				+"check_"+className+"( "+n+" ); "
				+cStruct+" "+c+" = val_"+className+"("+n+");\n" );
	}
	
	override public function cNekoAlloc( c:String ) :String {
		return( "alloc_"+className+"( "+c+" )" );
	}
}

class DynamicType extends TypeRep {
	public function new() :Void {
		super(null,"Dynamic","void*");
	}
	override public function cCheckAssign( c:String, n:String ) :String {
		return( "value "+c+" = "+n+";" );
	}
	override public function cNekoAlloc( c:String ) :String {
		return( c );
	}
}


class CPtrType extends TypeRep {
	var type:String;
	var minSize:String;
	var nullAllowed:Bool;
	
	public function new( t:String, m:String, n:Bool ) :Void {
		type = t;
		minSize = m;
		nullAllowed = n;
		super("cptr","Dynamic",type+"*");
	}

	override public function cCheckAssign( c:String, n:String ) :String {
		var r = asC()+" "+c+"; ";
		if( nullAllowed ) r += "if( "+n+" == val_null ) "+c+"=NULL; else { ";
			r += "val_check("+n+", string ); ";
			if( minSize != null ) {
				r += "if( val_strlen( "+n+" ) < sizeof("+type+")*"+minSize+" ) val_throw(alloc_string(\"cptr too small\")); ";
			}
			r+= c+"="+"("+type+"*)val_string("+n+"); ";
		if( nullAllowed ) r+="}";
		return r;
	}

	override public function cNekoAlloc( c:String ) :String {
		return( "val_throw( alloc_string(\"nekobind functions cannot return cptrs\") )" );
	}
}

class TypeRep {
	public var nekoRep:String;
	public var hxRep:String;
	public var cRep:String;

	public function new( n, hx, c ) :Void {
		nekoRep=n;
		hxRep=hx;
		cRep=c;
	}
	
	public function asNeko() :String {
		return nekoRep;
	}
	public function asHaxe() :String {
		return hxRep;
	}
	public function asC() :String {
		return cRep;
	}
	
	// ---------------- these are the ones actually used (apart from asX()) by the generators
	// todo: avoid all use of asXX?
	
	public function cCheckAssign( c:String, n:String ) :String {
		return( "val_check("+n+","+asNeko()+"); "
				+asC()+" "+c+" = "
				+"val_"+asNeko()+"("+n+");" );
	}
	
	public function cNekoAlloc( c:String ) :String {
		return( "alloc_"+asNeko()+"( "+c+" )" );
	}

	public function cReturn( c:String ) :String {
		return( "return( "+cNekoAlloc(c)+");" );
	}

}

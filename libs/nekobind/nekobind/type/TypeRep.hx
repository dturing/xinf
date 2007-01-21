/* 
   nekobind - nekovm-C binding generator
   Copyright (c) 2006, Daniel Fischer.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

package nekobind.type;
import haxe.rtti.Type;

class VoidType extends TypeRep {
    public function new() :Void {
        super(null,"Void","void");
    }
    public function cReturn( c:String ) :String {
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
    public function asNeko() :String {
        return "number";
    }
    // ...except alloc_
    public function cNekoAlloc( c:String ) :String {
        return( "alloc_"+nekoRep+"( "+c+" )" );
    }
}


class StringType extends TypeRep {
    public function new() :Void {
        super("string","String","const char*");
    }

    public function cCheckAssign( c:String, n:String ) :String {
        return(
                "if( val_is_object("+n+") ) "
                +n+" = val_field("+n+",val_id(\"__s\")); "
                +super.cCheckAssign( c, n ) );
    }
    public function cNekoAlloc( c:String ) :String {
        return( "alloc_"+nekoRep+"( (const char *)"+c+" )" );
    }
}


class FriendClassType extends TypeRep {
    var className:String;
    var cStruct:String;
    public function new( className:String, cStruct:String ) :Void {
        this.className = className.split(".").pop();
        this.cStruct = cStruct;
        super("abstract",className,cStruct+"*");
    }

    public function cCheckAssign( c:String, n:String ) :String {
        return(
                "check_"+className+"( "+n+" ); "
                +cStruct+"* "+c+" = val_"+className+"("+n+");\n" );
    }
    
    public function cNekoAlloc( c:String ) :String {
        return( "alloc_"+className+"( "+c+" )" );
    }
}

class DynamicType extends TypeRep {
    public function new() :Void {
        super(null,"Dynamic","void*");
    }
    public function cCheckAssign( c:String, n:String ) :String {
        return( "value "+c+" = "+n+";" );
    }
    public function cNekoAlloc( c:String ) :String {
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

    public function cCheckAssign( c:String, n:String ) :String {
        var r = asC()+" "+c+"; ";
        if( nullAllowed ) r += "if( "+n+" == val_null ) "+c+"=NULL; else { ";
            r += "val_check_kind("+n+", kind_import(\"cptr\") ); ";
            if( minSize != null ) {
                r += "val_cptr_check_size( "+n+", "+type+", "+minSize+" ); ";
            }
            r+= c+"="+"val_cptr("+n+","+type+"); ";
        if( nullAllowed ) r+="}";
        return r;
    }

    public function cNekoAlloc( c:String ) :String {
        return( "val_throw( alloc_string(\"nekobind cannot return cptrs\") )" );
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

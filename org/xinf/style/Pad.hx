package org.xinf.style;

class Pad {
    public var left:UnitValue;
    public var top:UnitValue;
    public var right:UnitValue;
    public var bottom:UnitValue;
    
    public static var NIL:Pad = new Pad( UnitValue.NIL, UnitValue.NIL, UnitValue.NIL, UnitValue.NIL );
    
    public function new( l:UnitValue, t:UnitValue, r:UnitValue, b:UnitValue ) {
        left=l; top=t; right=r; bottom=b;
    }
    
    public static function fromDynamic( v:Dynamic ) :Pad {
        switch( Reflect.typeof(v) ) {
            case TObject:
                if( Std.is(v,Pad) ) {
                    return cast(v,Pad);
                } else if( Std.is(v,String) ) {
                    return( fromString( cast(v,String) ) );
                } else {
                    throw("Cannot parse Pad from "+Reflect.getClass(v).__name__.join(".")+": "+v );
                }
            default:
                throw("Cannot parse Pad from "+Reflect.typeof(v)+": "+v );
        }
        return( Pad.NIL );
    }
    
    public static function fromString( v:String ) :Pad {
        var b = v.split(" ");
        
        if( b.length == 4 ) {
            return( new Pad( 
                UnitValue.fromString(b.shift()),
                UnitValue.fromString(b.shift()),
                UnitValue.fromString(b.shift()),
                UnitValue.fromString(b.shift()) ) );
        } else if( b.length == 1 ) {
            var p = UnitValue.fromString(b[0]);
            return( new Pad( p.clone(), p.clone(), p.clone(), p ) );
        } else {
            throw("Cannot parse Pad from '"+v+"'");
        }
        
        return( Pad.NIL );
    }
    
    public function toString() :String {
        return( ""+left+" "+top+" "+right+" "+bottom );
    }
}

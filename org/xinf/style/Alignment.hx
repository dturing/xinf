package org.xinf.style;

class Alignment {
    public var factor:Float;
    
    public static var LEFT:Alignment = new Alignment(.0);
    public static var CENTER:Alignment = new Alignment(.5);
    public static var RIGHT:Alignment = new Alignment(1.);
    public static var TOP:Alignment = new Alignment(.0);
    public static var MIDDLE:Alignment = new Alignment(.5);
    public static var BOTTOM:Alignment = new Alignment(1.);
    
    public function new( f:Float ) :Void {
        factor = f;
    }
    
    public static function fromDynamic( v:Dynamic ) :Alignment {
        switch( Reflect.typeof(v) ) {
            case TObject:
                if( Std.is(v,Alignment) ) {
                    return cast(v,Alignment);
                } else if( Std.is(v,String) ) {
                    return( fromString( cast(v,String) ) );
                } else {
                    throw("Cannot parse Alignment from "+Reflect.getClass(v).__name__.join(".")+": "+v );
                }
            default:
                throw("Cannot parse Alignment from "+Reflect.typeof(v)+": "+v );
        }
        return( new Alignment(.0) );
    }
    
    public static function fromString( v:String ) :Alignment {
        if( v == "left" ) {
            return LEFT;
        } else if( v == "center" ) {
            return CENTER;
        } else if( v == "right" ) {
            return RIGHT;
        } else if( v == "top" ) {
            return TOP;
        } else if( v == "middle" ) {
            return MIDDLE;
        } else if( v == "bottom" ) {
            return BOTTOM;
        }
        return( new Alignment(Std.parseFloat(v)) );
    }
    
    public function toString() :String {
        return( ""+factor );
    }
}

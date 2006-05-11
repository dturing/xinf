package org.xinf.style;

class Border {
    public var thickness:UnitValue;
    public var color:Color;
    public var style:String;
    
    // styles other than SOLID are not supported anywhere. FIXME there, then here :)
    public static var SOLID:String = "solid";
    
    public function new( t:UnitValue, s:String, c:Color ) :Void {
        thickness=t;
        color=c;
        style=s;
    }
    
    public static var NIL:Border = new Border(UnitValue.NIL,Border.SOLID,Color.NIL);
    public static var BLACK_1PX:Border = new Border(UnitValue.ONE_PX,Border.SOLID,Color.BLACK);
    
    public static function fromDynamic( v:Dynamic ) :Border {
        switch( Reflect.typeof(v) ) {
            case TObject:
                if( Std.is(v,Border) ) {
                    return cast(v,Border);
                } else if( Std.is(v,String) ) {
                    return( fromString( cast(v,String) ) );
                } else {
                    throw("Cannot parse Border from "+Reflect.getClass(v).__name__.join(".")+": "+v );
                }
            default:
                throw("Cannot parse Border from "+Reflect.typeof(v)+": "+v );
        }
        return( Border.NIL );
    }
    
    public static function fromString( v:String ) :Border {
        var b = v.split(" ");
        
        if( b.length == 3 ) {
            var thickness = UnitValue.fromString( b.shift() );
            var style = b.shift();
            var color = Color.fromString( b.shift() );

            return( new Border( thickness, style, color ) );
        } else if( v == "none" ) {
            return( Border.NIL );
        }
        throw("Cannot parse Border from '"+v+"'");
        return( Border.NIL );
    }
    
    public function toString() :String {
        return( ""+thickness+" "+style+" "+color );
    }
}

package xinfony.style;

class Border {
    public var thickness:UnitValue;
    public var color:Color;
    public var style:String;
    
    // styles other than SOLID are not supported anywhere. FIXME there, then here :)
    public static var SOLID:String = "solid";
    
    public function new( t:UnitValue, s:String, c:Color ) {
        thickness=t;
        color=c;
        style=s;
    }
    
    public static var NONE:Border = new Border(UnitValue.ZERO,Border.SOLID,Color.NIL);
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
        return( Border.NONE );
    }
    
    public static function fromString( v:String ) :Border {
        var b = v.split(" ");
        
        var thickness = UnitValue.fromString( b.shift() );
        var style = b.shift();
        var color = Color.fromString( b.shift() );
        
        return( new Border( thickness, style, color ) );
    }
    
    public function toString() :String {
        return( ""+thickness+" "+style+" "+color );
    }
}

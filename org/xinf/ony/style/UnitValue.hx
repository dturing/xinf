package xinfony.style;

enum Unit {
    px;
    em;
}

class UnitValue {
    public var unit:Unit;
    public var value:Float;
    
    public function new( v:Float, u:Unit ) {
        value=v;
        unit=u;
    }

    public function clone() {
        return( new UnitValue(value,unit) );
    }
    
    public static var NIL:UnitValue   = new UnitValue( 0.0, px );
    public static var ONE_PX:UnitValue = new UnitValue( 1.0, px );
    
    public function px() :Float {
        return( value *
            switch( unit ) {
                case px:
                    1.;
                case em:
                    5.; // FIXME
            } );
    }
    
    public static function fromDynamic( v:Dynamic ) :UnitValue {
        switch( Reflect.typeof(v) ) {
            case TObject:
                if( Std.is(v,UnitValue) ) {
                    return cast(v,UnitValue);
                } else if( Std.is(v,String) ) {
                    return( fromString( cast(v,String) ) );
                } else {
                    throw("Cannot parse UnitValue from "+Reflect.getClass(v).__name__.join(".")+": "+v );
                }
            case TInt:
                return( new UnitValue( v, px ) );
            case TFloat:
                return( new UnitValue( v, px ) );
            default:
                throw("Cannot parse UnitValue from "+Reflect.typeof(v)+": "+v );
        }
        return( UnitValue.NIL );
    }

    public static function fromString( s:String ) :UnitValue {
        var u = s.substr( s.length-2, 2 );
        var v = s.substr( 0, s.length-2 );
        
        var unit = px;
        if(      u == "px" ) unit = px;
        else if( u == "em" ) unit = em;
        else v=s;

        var v:UnitValue = new UnitValue( Std.parseFloat(v), unit );
        return v;
    }

    public function toString() :String {
        return( ""+value+unit );
    }
}

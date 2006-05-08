package xinfony.style;

enum Unit {
    px;
    em;
}

class UnitValue {
    public var unit:Unit;
    public var value:Float;
    
    public function new( v:Float, u:Unit ) {
        unit=u;
        value=v;
    }
    
    public static var ZERO:UnitValue   = new UnitValue( 0.0, px );
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

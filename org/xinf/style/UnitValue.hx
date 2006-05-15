package org.xinf.style;

import org.xinf.value.Value;
import org.xinf.event.Event;

enum Unit {
    px;
    em;
}

class UnitValue extends Value<Float> {
    public var unit:Unit;
    public var _v:Value<Float>;
    
    public function new( v:Value<Float>, u:Unit ) :Void {
        super(-.0);
        _v=v;
        unit=u;
        // FIXME: Event.CHANGED might not yet be initialized...
        _v.addEventListener( "changed", childChanged );
    }

    public function clone() :UnitValue {
        return( new UnitValue(_v,unit) );
    }

    private function childChanged( e:Event ) :Void {
      //  trace("UnitValue changed: "+this );
        changed();
    }

    // FIXME: if refactoring of Style to use Values turns out good, replace all px() bullcrap..
    public function px() :Float {
        return value;
    }        
    
    public static var NIL:UnitValue   = new UnitValue( new Value(0.0), px );
    public static var ONE_PX:UnitValue = new UnitValue( new Value(1.0), px );
    
    public function get_value() :Float {
        return( _v.value *
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
                } else if( untyped v.set_value != null ) { // workaround for Std.is(v,Value<Float>)
                    return( new UnitValue( untyped v, px ) );
                } else if( Std.is(v,String) ) {
                    return( fromString( cast(v,String) ) );
                } else {
                    return( fromString( v.toString() ) );
                }
            case TInt:
                return( new UnitValue( new Value<Float>(v), px ) );
            case TFloat:
                return( new UnitValue( new Value<Float>(v), px ) );
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

        var v:UnitValue = new UnitValue( new Value(Std.parseFloat(v)), unit );
        return v;
    }
    public function toString() :String {
        return( ""+_v+unit );
    }
}
